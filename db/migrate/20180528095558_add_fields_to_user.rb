class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string, null: false, default: ''
    add_column :users, :last_name, :string, null: false, default: ''
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :post_code, :string
  end
end
