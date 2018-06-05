FactoryBot.define do
  factory :order do
    user
    status { %w( paid cancelled processing).sample(1) }
    coupon { 'fortnite1' }
    details { 'Some details about the order...' }
    account_name { 'account' }
    account_password { 'password' }
    contact_email { Faker::Internet.email }
    skype { Faker::Internet.user_name }
    discord { Faker::Internet.user_name }
    preferred_communication { %w(skype discord email).sample(rand(1..3)).join(',') }

    factory :order_with_items do
      user
      after :create do |order|
        product = create :product
        create_list :order_item, 3, order: order, product: product
      end
    end
  end
end
