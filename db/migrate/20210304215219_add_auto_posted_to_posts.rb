class AddAutoPostedToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :auto_posted, :boolean
  end
end
