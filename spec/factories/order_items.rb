FactoryBot.define do
  factory :order_item do
    product
    order
    quantity { Faker::Number.positive 1, 20 }
    price { Faker::Number.positive 1, 20 }
    mode { %w(solo duo squad).sample(1) }
    platform { %w(pc xbox ps4).sample(1) }
    specials { %w(end9 stream oldbooster).sample(rand(0..3)).join(',') }
    account_name { %w(end9 stream oldbooster).sample(rand(0..3)).join(',') }
    password { %w(end9 stream oldbooster).sample(rand(0..3)).join(',') }
  end
end
