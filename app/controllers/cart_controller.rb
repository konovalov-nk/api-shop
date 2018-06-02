class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:create, :update, :index]

  # GET /cart
  def index
    render json: {
        order: {
            new: @order.id.nil?,
            details: @order.details,
            coupon: @order.coupon,
            invoice: @order.invoice,
        },
        items: @order.order_items.map { |item| {
            product_id: item.product_id,
            mode: item.mode,
            platform: item.platform,
            quantity: item.quantity,
            price: item.price,
            specials: item.specials,
        } },
    }, status: :ok
  end

  # POST /cart
  def create
    render json: @order.errors, status: :unprocessable_entity and return unless @order.save!

    order_items_params[:order_items].each do |order_item|
      @order.order_items.create(order_item)
    end

    @order.details = ''
    @order.coupon = ''
    if order_items_params.dig :order, :details
      @order.details = order_items_params[:order][:details]
    end
    if order_items_params.dig :order, :coupon
      @order.coupon = order_items_params[:order][:coupon]
    end

    if @order.save
      if params[:action] === 'create'
        UserMailer.order_received(current_user, @order).deliver_now
      else
        UserMailer.order_updated(current_user, @order).deliver_now
      end
      render json: {
          order: {
              new: @order.id.nil?,
              invoice: @order.invoice,
          },
      }, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cart
  def update
    @order.remove_items
    self.create
  end

  #
  # # DELETE /cart/1
  # def destroy
  #   @order.destroy
  # end

  private
    def set_order
      @order = Order.find_or_initialize_by(
        user_id: current_user.id,
        status: 'unpaid',
      )
    end

    def order_items_params
      params.permit(
        order_items: [:product_id, :quantity, :price, :mode, :platform, :specials],
        order: [:details, :coupon],
      ).tap do |filtered|
        filtered[:order_items].each do |o_i|
          o_i.require([:product_id, :quantity, :price, :mode, :platform])
        end
      end
    end
end
