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

    def send_photo(image, text = '')
      Telegram.bots[:default].send_photo(chat_id: @chat_id, photo: image, caption: text)
    end
    def send_animation(animation, text = '')
      Telegram.bots[:default].send_animation(chat_id: @chat_id, animation: animation, caption: text)
    end

    private

    def config
      Telegram.bots_config = {
        default: ENV['DEFAULT_BOT_TOKEN']
      }
    end
  end
end
