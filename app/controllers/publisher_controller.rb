class PublisherController < InheritedResources::Base
  def auto_posting
    chat = Chat.find(params[:id])
    PublisherService.new(chat).auto_posting
  end
end
