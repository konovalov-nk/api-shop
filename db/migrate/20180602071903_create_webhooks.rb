class CreateWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :webhooks do |t|
      t.string :webhook_id
      t.string :order_invoice
      t.text :payload

      t.timestamps
    end

    add_index :webhooks, :webhook_id
    add_index :webhooks, :order_invoice
  end
end
