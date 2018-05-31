class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :user, presence: true

  def remove_items
    self.order_items.destroy_all
  end
end
