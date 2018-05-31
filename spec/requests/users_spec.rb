require 'rails_helper'

RSpec.describe 'Users', type: :request do
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
        email: 'incorrect email'
    }
  }
  let(:user) { create(:user) }
  let(:user_jwt) { confirm_and_login(user) }
  let(:invalid_user) { create(:user) }
  let(:user_attributes) {
    {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        city: user.city,
        country: user.country,
        post_code: user.post_code,
    }
  }

  describe 'GET /users/test' do
    context 'as valid user' do
      it 'renders :ok response if signed in' do
        get_with_token '/users/test', { id: user.id }, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given invalid credentials' do
      it 'renders :unauthorized response' do
        user = create(:user)
        user.password = user.password_confirmation = 'wrong_password'
        jwt = confirm_and_login(user)

        get_with_token '/users/test', { id: user.id }, { 'Authorization' => jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user trying to fake identity' do
      it 'gives "Signature verification raised" error' do
        # Existing user.
        user1 = create(:user)

        # New user.
        user2 = create(:user)
        jwt_2 = confirm_and_login(user2)
        expect(response).to have_http_status(:created)

        jwt_split = jwt_2.split('.')

        # Temper with the sub id.
        payload = JSON.parse(Base64.decode64 jwt_split[1])
        payload['sub'] = user1.id.to_s
        # payload['exp'] = 123

        jwt_split[1] = Base64.encode64(payload.to_json).tr('+/', '-_').gsub(/[\n=]/, '')
        jwt = jwt_split.join('.')

        get_with_token '/users/test', { id: user1.id }, { 'Authorization' => jwt }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eql({ error: 'Signature verification raised' }.to_json)
      end
    end

    context 'as logged out user' do
      it 'responds with :unauthorized' do
        logout(user_jwt)

        get_with_token '/users/test', { id: user.id }, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /users/show/:id' do
    context 'as logged in user' do
      it 'responds with :ok' do
        get_with_token "/users/show/#{user.id}", {}, { 'Authorization' => user_jwt }
        expect(response).to have_http_status(:ok)
      end

      it 'shows user data' do
        get_with_token "/users/show/#{user.id}", {}, { 'Authorization' => user_jwt }
        expect(response.body).to eql(user_attributes.to_json)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid attributes' do
      it 'creates a new User' do
        expect {
          post_with_token '/users', user: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'responds with 201 for valid parameters' do
        post_with_token '/users', user: valid_attributes
        expect(response).to have_http_status(201)
      end

      it 'responds with json' do
        post_with_token '/users', user: valid_attributes

        expected = {
            id: 1,
            email: valid_attributes[:email],
        }

        hash = JSON.parse(response.body)
        expected.each { |k, v| expect(hash[k.to_s]).to eql(v) }
      end
    end

    context 'with invalid attributes' do
      before(:each) do
        @attributes = invalid_attributes
      end

      it 'does not create a new User' do
        expect {
          post_with_token '/users', user: @attributes
        }.to_not change(User, :count)
      end

      it 'responds with 422' do
        post_with_token '/users', user: @attributes
        expect(response).to have_http_status(422)
      end

      it 'shows errors' do
        post_with_token '/users', user: @attributes
        expected = {
            errors: {
                email: ['is invalid'],
                password: ["can't be blank"],
                first_name: ["can't be blank"],
                last_name: ["can't be blank"],
            }
        }.to_json

        expect(response.body).to eql(expected)
      end
    end
  end

  describe 'POST /users/sign_in' do
    context 'with valid attributes' do
      it 'responds with a success' do
        user = create(:user)
        confirm_and_login(user)

        expect(response).to be_success
      end
    end

    context 'given invalid password' do
      it 'responds with an unsuccess' do
        user = create(:user)
        user.password = 'wrong'
        confirm_and_login(user)

        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'as logged in user' do
      before(:each) do
        @user = create(:user)
        @jwt = confirm_and_login(@user)
      end

      it 'signs user out' do
        logout(@jwt)
        expect(response).to be_success
      end
    end

    context 'as logged out user' do
      before(:each) do
        @user = create(:user)
        @jwt = confirm_and_login(@user)
        logout(@jwt)
      end

      it 'changes JWT' do
        expect(@jwt).to_not eql(confirm_and_login(@user))
      end
    end

  end
end
