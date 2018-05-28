require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_attributes) {
    {
        email: Faker::Internet.email,
        password: 'example',
        password_confirmation: 'example',
    }
  }

  let(:invalid_attributes) {
    {
        email: 'incorrect email'
    }
  }

  let(:valid_session) { {} }

  describe 'GET /users/test' do
    context 'given valid credentials' do
      it 'renders :ok response if signed in' do
        user = create(:user)
        jwt = confirm_and_login(user)
        get '/users/test', headers: { 'Authorization' => jwt }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'given invalid credentials' do
      it 'redirects user' do
        user = create(:user)
        user.password = user.password_confirmation = 'wrong_password'
        jwt = confirm_and_login(user)
        get '/users/test', headers: { 'Authorization' => jwt }

        expect(response).to have_http_status(:redirect)
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
          post '/users', params: { user: @attributes }
        }.to change(User, :count).by(1)
      end

      it 'responds with 201 for valid parameters' do
        post '/users', params: { user: @attributes }
        expect(response).to have_http_status(201)
      end

      it 'renders json' do

        post '/users', params: { user: @attributes }
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
          post '/users', params: { user: @attributes }
        }.to_not change(User, :count)
      end

      it 'responds with 422' do
        post '/users', params: { user: @attributes }
        expect(response).to have_http_status(422)
      end

      it 'shows errors' do
        post '/users', params: { user: @attributes }
        expected = {
            errors: {
                email: ['is invalid'],
                password: ["can't be blank"],
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
        confirm_and_login(@user)
      end

      it 'signs user out' do
        logout(@user)

        expect(response).to be_success
      end
    end

    context 'given user is logged out' do
      before(:each) do
        @user = create(:user)
        confirm_and_login(@user)
        logout(@user)
      end

      it 'gives an error' do
        logout(@user)

        # expect(response).to_not be_success
      end
    end

  end
end
