class AddPosswordToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :username, :string
  end
end
