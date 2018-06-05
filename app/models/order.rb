class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  BASE_MULTIPLIER = 1.0
  BASE_VALUE_PER_GAME = 10
  MULT_DUO_EXTRA = 0.4
  MULT_SQUAD_EXTRA = 0.8
  BONUS_9_KILLS = 5
  BONUS_STREAM = 2
  BONUS_OLD_BOOSTER = 0

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

  def price_same?
    discount = self.coupon.downcase === 'fortnite1' ? 0.1 : 0.0
    self.order_items
        .map { |item| item.price - get_price(item, discount) }
        .reduce(0) { |r, price| r += price }.round(2) === 0.0
  end

  def total_price
    discount = self.coupon.downcase === 'fortnite1' ? 0.1 : 0.0
    self.order_items
        .map { |item| get_price(item, discount) }
        .reduce(0) { |r, price| r += price }.round(2)
  end

  def has_communications?
    communications = ['skype', 'discord', 'contact_email']
    self.preferred_communication.split(',').each do |c|
      return true if communications.include?(c) && self[c].length > 0
    end

    false
  end

  def needs_account_details?
    self.order_items
        .map { |item| not item.specials_array.include?('playbooster') }
        .reduce(false) { |r, not_include| r ||= not_include }
  end

  private

    def get_price(item, discount)
      specials = item.specials.split(',')
      multiplier = BASE_MULTIPLIER

      if specials.include?('playbooster')
        case item.mode
        when 'duo'
          multiplier += MULT_DUO_EXTRA
        when 'squad'
          multiplier += MULT_SQUAD_EXTRA
        else
          #
        end
      end

      value_per_game = BASE_VALUE_PER_GAME
      value_per_game += (specials.include?('end9') ? BONUS_9_KILLS : 0)
      value_per_game += (specials.include?('stream') ? BONUS_STREAM : 0)
      value_per_game += (specials.include?('oldbooster') ? BONUS_OLD_BOOSTER : 0)

      total = item.quantity * value_per_game
      if item.quantity >= 5
        if item.quantity < 10
          total -= 5
        else
          total -= ((item.quantity - (item.quantity % 5)) / 5) * value_per_game
        end
      end

      total * multiplier * (1.0 - discount)
    end
end
