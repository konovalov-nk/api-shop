FactoryBot.define do
  factory :order do
    user
    status { %w(unpaid paid cancelled) }

    factory :order_with_items do
      user
      status { 'unpaid' }
      after :create do |order|
        product = create :product
        create_list :order_item, 3, order: order, product: product
      end
    end
  end
end
