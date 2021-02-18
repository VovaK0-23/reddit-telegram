class AddLinkToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :link, :string
  end
end
