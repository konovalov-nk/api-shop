FactoryBot.define do
  factory :ipn do
    order_id 1
    ipn_track_id 'MyString'
    txn_id 'MyString'
    payer_id 'MyString'
    payload 'Some JSON here'
  end
end
