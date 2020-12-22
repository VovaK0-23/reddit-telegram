require 'telegram/bot'

module TelegramService
  class TelegramClient

    # выполняется когда ты пишешь TelegramService::TelegramClient.new()
    # сюда передай параметры для инициализации объекта(создания его), в нашем случае это токены
    def initialize(chat_id)
      config
      @chat_id = chat_id
    end

    # сюда передай сам месседж и выполни отправку
    # TelegramService::TelegramClient.new(...).send_message(your_message)
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
