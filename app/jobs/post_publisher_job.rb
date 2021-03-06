class PostPublisherJob < ApplicationJob
  queue_as :default

  def perform(chat)
    while Chat.find(chat.id).auto_posting == true
    PublisherService.new(chat).create
    PublisherService.new(chat).publish
    sleep(20.seconds)
    end
  end
end
