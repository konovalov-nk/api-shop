class AddInvoiceToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :invoice, :string
    add_index :orders, :invoice
  end
end
