class PublisherService
  MAX_VALID_IMAGE_SIZE = 5_242_880
  MAX_RESIZED_IMAGE_SIZE = 10_485_760
  MAX_VALID_GIF_SIZE = 20_971_520
  MAX_RESIZED_GIF_SIZE = 52_428_800

  def initialize(chat)
    @chat = chat
  end

  def auto_post
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

  def initialize_post
    until @saved
      receive_post
      create_post
    end
  end

  def publish
    @post = Post.where(chat_id: @chat.id, auto_posted: true, published_at: nil).last
    @post.update(published_at: Time.zone.now)
    chat = @post.chat


    service = TelegramService::TelegramClient
    link = @post.link

    if link.blank?
      service.send_message(chat.name, post.body)
    elsif link.include?('.gif') or link.include?('.mp4?source=fallback')
      file = valid_gif(link)
      return if file == false

      service.send_animation(chat.name, file, @post.body)
    else
      if link.include?('.jpeg') or link.include?('.jpg') or link.include?('.png')
        service.send_photo(chat.name, valid_image(link, 95), @post.body)
      end
      service.send_video(chat.name, link, @post.body) if link.include?('.mp4')
    end
  end

  def valid_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    return link if image.size <= MAX_VALID_IMAGE_SIZE

    resize_image(link, resize_value)
  end

  def resize_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size > MAX_RESIZED_IMAGE_SIZE
      image = MiniMagick::Image.new(image.path)
      while image.size > MAX_RESIZED_IMAGE_SIZE
        image.resize(resize_value.to_s + '%')
        resize_value - 5
      end
    end
    Faraday::UploadIO.new(image.path, image.type)
  end

  def valid_gif(link)
    gif = MiniMagick::Image.open(link)
    return link if gif.size <= MAX_VALID_GIF_SIZE

    resize_gif(link)
  end

  def resize_gif(link)
    gif = MiniMagick::Image.open(link)
    if gif.size <= MAX_RESIZED_GIF_SIZE
      Faraday::UploadIO.new(gif.path, gif.type)
    else
      false
    end
  end

  private

  def receive_post
    service = RedditService::RedditClient.receive_posts(
        @chat.subreddit + @chat.subreddit_sorting,
        @chat.limit,
        @chat.time,
        @after_token
      )
    @posts = service[:posts]
    @after_token = service[:after_token]
  end

  def create_post
    @posts.each do |p|
      post = Post.new
      next if p['stickied'] == true or p['is_gallery'] == true

      post.body = p['title']
      if p['crosspost_parent_list'].present?
        if p['crosspost_parent_list'].first['is_video'] == true
          post.link = p['crosspost_parent_list'].first['media']['reddit_video']['fallback_url']
        elsif p['crosspost_parent_list'].first['domain'] == 'i.imgur.com' && p['crosspost_parent_list'].first['url_overridden_by_dest'].include?('.gifv')
          post.link = p['crosspost_parent_list'].first['preview']['reddit_video_preview']['fallback_url']
        else
          post.link = p['crosspost_parent_list'].first['url']
        end
      else
        post.link = if p['is_video'] == true
                      p['media']['reddit_video']['fallback_url']
                    elsif p['domain'] == 'i.imgur.com' && p['url_overridden_by_dest'].include?('.gifv')
                      p['preview']['reddit_video_preview']['fallback_url']
                    else
                      p['url']
                    end
      end
      post.chat_id = @chat.id
      post.user_id = @chat.user_id
      post.auto_posted = true
      next unless post.save

      @saved = true
      break
    end
  end
end
