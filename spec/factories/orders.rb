FactoryBot.define do
  factory :order do
    user
    status { %w(unpaid paid cancelled) }
    coupon { 'fortnite1' }
    details { 'Some details about the order...' }

    factory :order_with_items do
      user
      status { 'unpaid' }
      coupon { 'fortnite1' }
      details { 'Some details about the order...' }
      after :create do |order|
        product = create :product
        create_list :order_item, 3, order: order, product: product
      end
    end
  end
end
