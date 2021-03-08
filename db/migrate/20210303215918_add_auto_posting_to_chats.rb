class AddAutoPostingToChats < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :auto_posting, :boolean
  end
end
