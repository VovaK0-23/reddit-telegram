class PublisherService
  def initialize(chat)
    @chat = chat
  end

  def auto_posting
      chat_id = @chat.id

      rs = Sidekiq::RetrySet.new.select
      rs.map do |r|
        @rw = r.item.to_hash['args'].first['arguments'].first['_aj_globalid'].include?(chat_id.to_s)
      end

      ss = Sidekiq::ScheduledSet.new.select
      ss.map do |j|
        @sw = j.item.to_hash['args'].first['arguments'].first['_aj_globalid'].include?(chat_id.to_s)
      end

      if @rw or @sw == true
        nil
      else
        PostPublisherJob.perform_later(@chat)
      end
  end

  def create
    until @saved
      service = RedditService::RedditClient.new.receive_posts(
          @chat.subreddit + @chat.subreddit_sorting,
          @chat.limit,
          @chat.time,
          @after_token)
      @posts = service[:posts]
      @after_token = service[:after_token]
      @posts.each do |p|
        post = Post.new
        next if p['stickied'] == true or p['is_gallery'] == true
        post.body = p['title']
        if p['crosspost_parent_list'].present?
          if p['crosspost_parent_list'].first['is_video'] == true
            post.link = p['crosspost_parent_list'].first['media']['reddit_video']['fallback_url']
          elsif p['crosspost_parent_list'].first['domain'] == "i.imgur.com" && p['crosspost_parent_list'].first['url_overridden_by_dest'].include?(".gifv")
            post.link = p['crosspost_parent_list'].first['preview']['reddit_video_preview']['fallback_url']
          else
            post.link = p['crosspost_parent_list'].first['url']
          end
        else
          if p['is_video'] == true
            post.link = p['media']['reddit_video']['fallback_url']
          elsif p['domain'] == "i.imgur.com" && p['url_overridden_by_dest'].include?(".gifv")
            post.link = p['preview']['reddit_video_preview']['fallback_url']
          else
            post.link = p['url']
          end
        end
        post.chat_id = @chat.id
        post.user_id = @chat.user_id
        post.auto_posted = true

        if post.save
          @saved = true
          break
        else
          next
        end
      end
    end
  end

  def publish
    @post = Post.where(chat_id: @chat.id, auto_posted: true, published_at: nil).last
    @post.update(published_at: Time.zone.now)
    chat = @post.chat


    service = TelegramService::TelegramClient.new(chat.name)
    link = @post.link

    if link.blank?
      service.send_message(post.body)
    elsif link.include?(".gif") or link.include?(".mp4?source=fallback")
      file = valid_gif(link)
      if file == false
        return
      else
        service.send_animation(file, @post.body)
      end
    else
      service.send_photo(valid_image(link, 95), @post.body) if link.include?(".jpeg") or link.include?(".jpg") or link.include?(".png")
      service.send_video(link, @post.body) if link.include?(".mp4")
    end
  end

  def resize_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size > 10485760
      image = MiniMagick::Image.new(image.path)
      while image.size > 10485760
        image.resize(resize_value.to_s + '%')
        resize_value - 5
      end
    end
    Faraday::UploadIO.new(image.path, image.type)
  end

  def valid_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size <= 5242880
      return link
    end
    resize_image(link, resize_value)
  end

  def resize_gif(link)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 52428800
      Faraday::UploadIO.new(gif.path, gif.type)
    else
      false
    end
  end

  def valid_gif(link)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 20971520
      return link
    end
    resize_gif(link)
  end

end
