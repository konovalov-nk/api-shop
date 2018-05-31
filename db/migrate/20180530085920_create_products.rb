class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :image_url
      t.decimal :price
      t.text :description
      t.text :specials

      t.timestamps
    end

    add_index :products, :title
  end
end
