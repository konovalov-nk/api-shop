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
            account_name: item.account_name,
            password: item.password,
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

    render json: {
        error: "Incorrect price. Should be equal to #{@order.total_price}"
    }, status: :unprocessable_entity and return unless @order.price_same?

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

  def complete
    if invoice_params.dig(:order, :invoice)
      order = Order.find_by_invoice(invoice_params[:order][:invoice])
      if order.status === 'unpaid'
        order.status = 'processing'
        order.save!
      end
    end
    render json: {}, status: :ok
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
        order_items: [:product_id, :quantity, :price, :mode, :platform, :specials, :account_name, :password],
        order: [:details, :coupon],
      ).tap do |filtered|
        filtered[:order_items].each do |o_i|
          o_i.require([:product_id, :quantity, :price, :mode, :platform, :account_name, :password])
        end
      end
    end

    def invoice_params
      params
    end
end
