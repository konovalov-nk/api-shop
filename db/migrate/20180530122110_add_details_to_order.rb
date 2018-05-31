class AddDetailsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :details, :string
  end
end
