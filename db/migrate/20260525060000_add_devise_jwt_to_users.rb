class AddDeviseJwtToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :role, :string, null: false, default: "customer"

    users = Class.new(ActiveRecord::Base) { self.table_name = "users" }
    users.reset_column_information
    users.where(email: [ nil, "" ]).find_each do |user|
      user.update_columns(email: "user-#{user.id}@example.local")
    end

    change_column_null :users, :email, false
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :role
  end

  def down
    remove_index :users, :role
    remove_index :users, :reset_password_token
    remove_index :users, :email
    remove_column :users, :role
    remove_column :users, :remember_created_at
    remove_column :users, :reset_password_sent_at
    remove_column :users, :reset_password_token
    remove_column :users, :encrypted_password
  end
end
