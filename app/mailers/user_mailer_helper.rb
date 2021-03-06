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
    "Fortnite Boost - Mode: #{item.mode.upcase}, Platform: #{item.platform.upcase}, Amount: #{item.quantity}#{specials(item)}. -- #{price(item)}"
  end

  def we_will_contact(order)
    preferred_methods = order.preferred_methods.split(',')

    methods, count = [
        preferred_methods.map { |m| "#{m.upcase_first} - #{order[m]}" }.join(', '),
        preferred_methods.count,
    ]

    if order.account_name
      "We will contact you soon for your account \"#{order.account_name}\" " \
      "using your preferred contact #{count > 1 ? Inflector.pluralize('method') : 'method'}: #{methods}."
    else
      'We will contact you soon using your preferred contact ' \
      "#{count > 1 ? Inflector.pluralize('method') : 'method'}: #{methods}."
    end
  end
end
