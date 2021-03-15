class RemovePasswordDigestToUsers < ActiveRecord::Migration[6.0]
  remove_column :users, :password_digest
end
