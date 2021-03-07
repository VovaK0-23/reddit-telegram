class PostPublisherJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    if Chat.find(@chat.id).auto_posting == true
      time = Chat.find(@chat.id).auto_posting_time
    self.class.set(:wait => time.minutes).perform_later(job.arguments.first)
    end
  end

  def perform(chat)
    @chat = chat
    PublisherService.new(chat).create
    PublisherService.new(chat).publish
  end
end
