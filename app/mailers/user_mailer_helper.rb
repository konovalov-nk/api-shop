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

  def description(item)
    "Fortnite Boost - Mode: #{item.mode.upcase}, Platform: #{item.platform.upcase}, Amount: #{item.quantity}, Account: #{item.account_name}#{specials(item)}. -- #{price(item)}"
  end

  def accounts(order)
    accounts, count = [order.order_items.map { |item| item.account_name }.join(', '), order.order_items.count]
    "We will contact you soon for your #{count > 1 ? Inflector.pluralize('accounts') : 'account'}: #{accounts}"
  end
end
