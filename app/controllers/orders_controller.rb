class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid, only: [:index, :show, :create, :update, :destroy]
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders/history
  def history
    @orders = Order.where(user_id: current_user.id).order('created_at DESC').all
    render json: @orders.to_json(include: :order_items)
  end

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:user_id, :status)
    end
end
