FactoryBot.define do
  factory :order_item do
    product
    order
    quantity { Faker::Number.positive 1, 20 }
    mode { 'solo' }
    platform { 'pc' }
    specials { 'end9,stream,oldbooster' }
  end
end
