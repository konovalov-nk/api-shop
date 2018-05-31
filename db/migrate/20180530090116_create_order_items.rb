class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.decimal :price
      t.text :specials

      t.timestamps
    end

    add_index :order_items, :product_id
    add_index :order_items, :order_id
  end
end
