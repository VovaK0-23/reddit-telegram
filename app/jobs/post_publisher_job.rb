class PostPublisherJob < ApplicationJob
  queue_as :default

  def perform(*set_chat)

  end
end
