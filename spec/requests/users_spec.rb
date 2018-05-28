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

  describe 'GET /users/test' do
    context 'given valid credentials' do
      it 'renders :ok response if signed in' do
        user = create(:user)
        jwt = confirm_and_login(user)
        get_with_token '/users/test', { id: user.id }, { 'Authorization' => jwt }

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

    context 'given user is logged out' do
      it 'renders :unauthorized response if signed in' do
        attributes = valid_attributes
        user = create(:user, attributes)
        jwt = confirm_and_login(user)
        logout(jwt)

        get_with_token '/users/test', { id: user.id }, { 'Authorization' => jwt }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /users/show/:id' do
    context 'given user is logged in' do
      it 'renders response' do
        attributes = valid_attributes
        user = create(:user, attributes)
        jwt = confirm_and_login(user)

        get_with_token "/users/show/#{user.id}", {}, { 'Authorization' => jwt }

        expect(response).to have_http_status(:ok)

        expected = {
            id: user.id,
            email: attributes[:email],
            first_name: attributes[:first_name],
            last_name: attributes[:last_name],
            city: attributes[:city],
            country: attributes[:country],
            post_code: attributes[:post_code],
        }
        hash = JSON.parse(response.body)

        expected.each { |k, v| expect(hash[k.to_s]).to eql(v) }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /users' do
    context 'given valid attributes' do
      before(:each) do
        @attributes = valid_attributes
      end

      it 'creates a new User' do
        expect {
          post_with_token '/users', user: @attributes
        }.to change(User, :count).by(1)
      end

      it 'responds with 201 for valid parameters' do
        post_with_token '/users', user: @attributes
        expect(response).to have_http_status(201)
      end

      it 'renders json' do
        post_with_token '/users', user: @attributes
        expected = {
            id: 1,
            email: @attributes[:email],
        }

        hash = JSON.parse(response.body)
        expected.each { |k, v| expect(hash[k.to_s]).to eql(v) }
      end
    end

    context 'given invalid attributes' do
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
    context 'given valid attributes' do
      it 'renders a successful response' do
        user = create(:user)
        confirm_and_login(user)

        expect(response).to be_success
      end
    end

    context 'given invalid password' do
      it 'renders an unsuccessful response' do
        user = create(:user)
        user.password = 'wrong'
        confirm_and_login(user)

        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'given user is logged in' do
      before(:each) do
        @user = create(:user)
        @jwt = confirm_and_login(@user)
      end

      it 'signs user out' do
        logout(@jwt)

        expect(response).to be_success
      end
    end

    context 'given user is logged out' do
      before(:each) do
        @user = create(:user)
        @jwt = confirm_and_login(@user)
        logout(@jwt)
      end

      it 'JWT is not the same' do
        jwt = confirm_and_login(@user)

        expect(@jwt).to_not eql(jwt)
      end
    end

  end
end
