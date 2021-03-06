class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :show, :update, :destroy, :test]
  before_action :set_user, only: [:show, :update, :destroy, :test]
  before_action :forbid, only: [:index, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/test
  def test
    render json: {}, status: :ok
  end

  # GET /users/1
  def show
    render json: @user.slice(
      :id, :email, :first_name, :last_name, :city,
        :country, :post_code, :account_name, :account_password,
        :skype, :discord, :contact_email, :preferred_communication
    ).merge(
      tawk_to_hash: OpenSSL::HMAC.hexdigest('SHA256', ENV['TAWK_TO_API_KEY'], @user.email)
    )
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {}).permit(:email, :first_name, :last_name, :country, :city, :post_code)
    end
end
