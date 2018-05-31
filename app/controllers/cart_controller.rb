class CartController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_order, only: [:create]

  # POST /cart
  def create
    order_items_params[:order_items].each do |order_item|
      @order.order_items.create!(order_item)
    end

    @order.details = ''
    if order_items_params.dig :order, :details
      @order.details = order_items_params[:order][:details]
    end

    if @order.save
      render json: { order_id: @order.id }, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /cart/1
  # def update
  #   if @order.update(order_params)
  #     render json: @order
  #   else
  #     render json: @order.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /cart/1
  # def destroy
  #   @order.destroy
  # end

  private
    def set_order
      @order = Order.find_or_create_by(user_id: current_user.id, status: 'new')
      @order.status = 'unpaid'
    end

    def order_items_params
      params.permit(
        order_items: [:product_id, :quantity, :price, specials: []],
        order: :details
      ).tap do |filtered|
        filtered[:order_items].each do |o_i|
          o_i.require([:product_id, :quantity, :price, :specials])
        end
      end
    end
end
