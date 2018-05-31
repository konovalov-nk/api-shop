FactoryBot.define do
  factory :order do
    user
    status { %w(unpaid paid cancelled) }
  end
end
