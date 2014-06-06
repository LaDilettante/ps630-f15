class AddHashedTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hashed_token, :string
    add_index :users, :hashed_token
  end
end
