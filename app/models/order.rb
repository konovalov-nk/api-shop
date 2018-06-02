class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :user, presence: true
  validates :invoice, uniqueness: true

  def remove_items
    self.order_items.destroy_all
  end

  def generate_invoice
    self.invoice = "#{Time.now.strftime('%Y-%m-%d')}/#{rand(36**8).to_s(36)[0..3].upcase}"
    generate_invoice if Order.exists?(invoice: self.invoice)
  end

  after_initialize do
    generate_invoice if self.new_record?
  end
end
