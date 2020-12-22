require 'telegram/bot'

module TelegramService
  class TelegramClient
    def initialize(chat_id)
      config
      @chat_id = chat_id
    end

    def send_message(message)
      Telegram.bots[:default].send_message(chat_id: @chat_id, text: message)
    end

    private

    def config
      Telegram.bots_config = {
        default: ENV['DEFAULT_BOT_TOKEN']
      }
    end
  end
end
