class PostPublisherJob < ApplicationJob
  queue_as :default

  def perform(chat)
    while chat.auto_posting == true
    PublisherService.new(chat).create
    PublisherService.new(chat).publish
    sleep(10.seconds)
    end
  end
end
