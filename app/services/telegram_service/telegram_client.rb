require 'telegram/bot'

module TelegramService
  class TelegramClient

    def self.send_message(chat_id, message)
      Telegram.bots[:default].send_message(chat_id: chat_id, text: message)
    end

    def self.send_photo(chat_id, image, text = '')
      Telegram.bots[:default].send_photo(chat_id: chat_id, photo: image, caption: text)
    end

    def self.send_animation(chat_id, animation, text = '')
      Telegram.bots[:default].send_animation(chat_id: chat_id, animation: animation, caption: text)
    end

    def self.send_video(chat_id, video, text = '')
      Telegram.bots[:default].send_video(chat_id: chat_id, video: video, caption: text)
    end
  end
end
