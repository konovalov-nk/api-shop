class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  BASE_MULTIPLIER = 1.0
  BASE_VALUE_PER_GAME = 10
  MULT_DUO_EXTRA = 0.4
  MULT_SQUAD_EXTRA = 0.8
  MULT_PLAY_BOOSTER = 0.4
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

  private

    def get_price(item, discount)
      specials = item.specials.split(',')
      multiplier = BASE_MULTIPLIER

      case item.mode
      when 'solo'
      when 'duo'
        multiplier += MULT_DUO_EXTRA
      else
        multiplier += MULT_SQUAD_EXTRA
      end

      if specials.include?('playbooster')
        multiplier += MULT_PLAY_BOOSTER
      end

      multiplier -= discount

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
      total *= multiplier
    end
end
