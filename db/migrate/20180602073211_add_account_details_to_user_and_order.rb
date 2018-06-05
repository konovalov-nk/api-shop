class AddAccountDetailsToUserAndOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :account_name, :string
    add_column :orders, :account_password, :string
    add_column :orders, :discord, :string
    add_column :orders, :contact_email, :string
    add_column :orders, :skype, :string
    add_column :orders, :preferred_communication, :string

    add_column :users, :account_name, :string
    add_column :users, :account_password, :string
    add_column :users, :discord, :string
    add_column :users, :contact_email, :string
    add_column :users, :skype, :string
    add_column :users, :preferred_communication, :string
  end
end
