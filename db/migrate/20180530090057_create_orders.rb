class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :status
      t.string :coupon

      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :status
  end
end
