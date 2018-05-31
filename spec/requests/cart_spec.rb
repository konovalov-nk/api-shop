require 'rails_helper'

RSpec.describe 'Cart', type: :request do
  before(:each) do
    create(:product)
  end

  let(:valid_attributes) {
    {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        city: Faker::Address.city,
        country: Faker::Address.country_code_long.downcase,
        post_code: Faker::Address.postcode,
        password: 'example',
        password_confirmation: 'example',
    }
  }
  let(:invalid_attributes) {
    {
        first_name: Faker::Name.first_name,
        email: 'invalid email',
        password: 'example',
        password_confirmation: 'example',
    }
  }
  let(:user) { create(:user, valid_attributes) }
  let(:user_jwt) { confirm_and_login(user) }
  let(:invalid_user) { create(:user, invalid_attributes) }
  let(:valid_params) { {
      order: { details: 'Some details...' },
      order_items: [
          { product_id: 1, quantity: 3, price: 30.0, specials: ['end9'] },
          { product_id: 1, quantity: 4, price: 40.0, specials: %w(end9 stream oldbooster) },
          { product_id: 1, quantity: 5, price: 50.0, specials: [] },
      ]
  } }
  let(:invalid_params) { {
      stuff: { details: 'Some details...' },
      order_items: [
          { quantity: 9, price: 99.0, specials: ['end9'] },
          { product_id: 9, specials: %w(end9 stream oldbooster) },
          { product_id: 9, quantity: 9 },
      ]
  } }

  describe 'POST /cart/create' do
    context 'as valid user' do
      it 'responds with 201 for valid parameters' do
        post_with_token '/cart/create', valid_params, 'Authorization' => user_jwt

        expect(response).to have_http_status(:created)
      end

      it 'returns order number' do
        post_with_token '/cart/create', valid_params, 'Authorization' => user_jwt

        expect(response.body).to eql({ order_id: 1 }.to_json)
      end

      it 'creates an order' do
        expect {
          post_with_token '/cart/create', valid_params, 'Authorization' => user_jwt
        }.to change(Order, :count).by(1)
      end

      it 'creates an order without order details' do
        valid_params[:order] = nil
        expect {
          post_with_token '/cart/create', valid_params, 'Authorization' => user_jwt
        }.to change(Order, :count).by(1)
      end

      it 'raises ParameterMissing error with invalid params' do
        expect {
          post_with_token '/cart/create', invalid_params, 'Authorization' => user_jwt
        }.to raise_error ActionController::ParameterMissing
      end
    end

    context 'as invalid user' do
      it 'responds with :unauthorized' do
        post_with_token '/cart/create', valid_params, 'Authorization' => 'Bearer 123.2345.2431'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'logged out user' do
      it 'responds with :unauthorized' do
        logout(user_jwt)
        post_with_token '/cart/create', {}, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
