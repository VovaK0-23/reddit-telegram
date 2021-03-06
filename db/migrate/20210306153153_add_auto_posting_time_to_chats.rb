class AddAutoPostingTimeToChats < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :auto_posting_time, :integer
  end
end
