class PublisherController < InheritedResources::Base
  def auto_posting
    chat = Chat.find(params[:id])
    chat.update(:auto_posting => true)
    PublisherService.new(chat).auto_posting
  end

  def auto_posting_stop
    chat = Chat.find(params[:id])
    chat.update(:auto_posting => false)
  end
end
