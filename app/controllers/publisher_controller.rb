class PublisherController < InheritedResources::Base
  def update
    @chat = Chat.find(params[:id])
    if @chat.auto_posting_time.nil?
      @chat.update(auto_posting_time: 30)
    else
      @chat.update(chat_params)
    end

    if @chat.auto_posting == true
      auto_publisher_stop
    else
      auto_publisher
    end

    redirect_to chat_path
  end

  private

  def auto_publisher
    @chat.update(auto_posting: true)
    PublisherService.new(@chat).auto_post
    sleep(30.seconds)
  end

  def auto_publisher_stop
    @chat.update(auto_posting: false)
  end

  def chat_params
    params.require(:chat).permit(:auto_posting, :auto_posting_time)
  end

end
