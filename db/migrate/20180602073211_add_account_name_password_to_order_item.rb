class AddAccountNamePasswordToOrderItem < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :account_name, :string
    add_column :order_items, :password, :string
    add_index :order_items, :account_name
  end
end
