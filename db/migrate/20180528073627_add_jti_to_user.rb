class AddJtiToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :jti, :string, null: false, default: ''
    add_index :users, :jti, unique: true
  end
end
