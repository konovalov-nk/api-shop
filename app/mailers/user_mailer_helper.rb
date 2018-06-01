module UserMailerHelper
  def specials(item)
    specials_names = {
        'end9' => 'End game with 9 or more kills',
        'stream' => 'Stream my boost',
        'oldbooster' => 'I want my old booster',
    }

    specials = item.specials
        .split(',')
        .map { |item| specials_names[item] }
        .join(', ')
    specials.length > 0 ? ", Specials: #{specials}" : ''
  end

  def price(item)
    "$#{item.price}"
  end

  def total(order)
    '$' + order.order_items.reduce(0) { |sum, item| sum += item.price }.to_s
  end

  def coupon(order)
    "Promo Code: #{order.coupon.upcase}, 10% discount" if order.coupon.downcase === 'fortnite1'
  end
end
