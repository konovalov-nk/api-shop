class CreateIpns < ActiveRecord::Migration[5.1]
  def change
    create_table :ipns do |t|
      t.string :order_invoice
      t.string :ipn_track_id
      t.string :txn_id
      t.string :payer_id
      t.text :payload

      t.timestamps
    end

    add_index :ipns, :order_invoice
    add_index :ipns, :ipn_track_id
    add_index :ipns, :txn_id
    add_index :ipns, :payer_id
  end
end
