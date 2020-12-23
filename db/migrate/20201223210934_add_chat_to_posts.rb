class AddChatToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :chat, null: false, foreign_key: true
  end
end
