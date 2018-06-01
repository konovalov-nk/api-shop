require 'rails_helper'

RSpec.describe 'Cart', type: :request do
  before(:each) do
    @product = create(:product)
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
          { product_id: 1, quantity: 3, price: 30.0, platform: 'pc', mode: 'solo', specials: 'end9' },
          { product_id: 1, quantity: 4, price: 40.0, platform: 'pc', mode: 'solo', specials: 'end9,stream,oldbooster' },
          { product_id: 1, quantity: 5, price: 50.0, platform: 'pc', mode: 'solo', specials: '' },
      ]
  } }
  let(:invalid_params) { {
      stuff: { details: 'Some details...' },
      order_items: [
          { quantity: 9, price: 99.0, specials: 'end9' },
          { product_id: 9, specials: 'end9,stream,oldbooster' },
          { product_id: 9, quantity: 9 },
      ]
  } }

  describe 'POST /cart' do
    context 'as valid user' do
      it 'responds with 201 for valid parameters' do
        post_with_token '/cart', valid_params, 'Authorization' => user_jwt

        expect(response).to have_http_status(:created)
      end

      it 'returns order number' do
        post_with_token '/cart', valid_params, 'Authorization' => user_jwt
        expect(response.body).to eql({ order: { id: 1 } }.to_json)
      end

      it 'creates an order' do
        expect {
          post_with_token '/cart', valid_params, 'Authorization' => user_jwt
        }.to change(Order, :count).by(1)
      end

      it 'creates an order without order details' do
        valid_params[:order] = nil
        expect {
          post_with_token '/cart', valid_params, 'Authorization' => user_jwt
        }.to change(Order, :count).by(1)
      end

      it 'creates an order without specials' do
        valid_params[:order_items][0][:specials] = ''
        expect {
          post_with_token '/cart', valid_params, 'Authorization' => user_jwt
        }.to change(Order, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'raises ParameterMissing error with invalid params' do
        expect {
          post_with_token '/cart', invalid_params, 'Authorization' => user_jwt
        }.to raise_error ActionController::ParameterMissing
      end
    end

    context 'as invalid user' do
      it 'responds with :unauthorized' do
        post_with_token '/cart', valid_params, 'Authorization' => 'Bearer 123.2345.2431'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'logged out user' do
      it 'responds with :unauthorized' do
        logout(user_jwt)
        post_with_token '/cart', {}, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /cart' do
    before(:each) do
      @product = create(:product)
      @order_with_items = create(:order_with_items)
      @order_user_jwt = confirm_and_login(@order_with_items.user)
    end

    context 'as valid user' do
      it 'responds with 201 for valid parameters' do
        put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        expect(response).to have_http_status(:created)
      end

      it 'returns order number' do
        put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        expect(response.body).to eql({ order: { id: 1 } }.to_json)
      end

      it 'does not create new order' do
        expect {
          put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        }.to change(Order, :count).by(0)
        expect(response).to have_http_status(:created)
      end

      it 'updates the order' do
        expect {
          put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        }.to change(Order, :count).by(0)
        expect(response).to have_http_status(:created)
      end

      it 'changes an order without order details' do
        valid_params[:order] = nil
        expect {
          put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        }.to change(Order, :count).by(0)
        expect(response).to have_http_status(:created)
      end

      it 'changes an order without specials' do
        valid_params[:order_items][0][:specials] = ''
        expect {
          put_with_token '/cart', valid_params, 'Authorization' => @order_user_jwt
        }.to change(Order, :count).by(0)
        expect(response).to have_http_status(:created)
      end

      it 'raises ParameterMissing error with invalid params' do
        expect {
          put_with_token '/cart', invalid_params, 'Authorization' => @order_user_jwt
        }.to raise_error ActionController::ParameterMissing
      end
    end

    context 'as invalid user' do
      it 'responds with :unauthorized' do
        put_with_token '/cart', valid_params, 'Authorization' => 'Bearer 123.2345.2431'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'logged out user' do
      it 'responds with :unauthorized' do
        logout(@order_user_jwt)
        put_with_token '/cart', {}, { 'Authorization' => @order_user_jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /cart' do
    before(:each) do
      @product = create(:product)
      @order_with_items = create(:order_with_items)
      @order_user_jwt = confirm_and_login(@order_with_items.user)
      @user_jwt = confirm_and_login(@order_with_items.user)
    end

    context 'as valid user with existing order' do
      it 'responds with 200' do
        get_with_token '/cart', {}, { 'Authorization' => @order_user_jwt }
        expect(response).to have_http_status(:ok)
      end

      it 'returns order number' do
        get_with_token '/cart', {}, { 'Authorization' => @order_user_jwt }
        expect(JSON.parse(response.body)['order']['id']).to eql(1)
      end

      it 'returns order items' do
        get_with_token '/cart', {}, { 'Authorization' => @order_user_jwt }
        expect(JSON.parse(response.body)['items'].size).to be > 0
      end
    end

    context 'as a valid user without existing order' do
      it 'responds with 200' do
        get_with_token '/cart', {}, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:ok)
      end

      it 'returns 0 for order_id' do
        get_with_token '/cart', {}, { 'Authorization' => user_jwt }
        expect(JSON.parse(response.body)['order']['id']).to eql(0)
      end
    end

    context 'as invalid user' do
      it 'responds with :unauthorized' do
        get_with_token '/cart', {}, { 'Authorization' => 'Bearer 123.2345.2431' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'logged out user' do
      it 'responds with :unauthorized' do
        logout(@order_user_jwt)
        get_with_token '/cart', {}, { 'Authorization' => @order_user_jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
