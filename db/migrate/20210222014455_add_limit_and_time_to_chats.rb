class AddLimitAndTimeToChats < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :limit, :integer
    add_column :chats, :time, :string
  end
end
