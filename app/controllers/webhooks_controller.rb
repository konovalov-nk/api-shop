class WebhooksController < ApplicationController
  before_action :forbid
  # before_action :set_webhook, only: [:show, :update, :destroy]
  #
  # # GET /webhooks
  # def index
  #   @webhooks = Webhook.all
  #
  #   render json: @webhooks
  # end
  #
  # # GET /webhooks/1
  # def show
  #   render json: @webhook
  # end
  #
  # # POST /webhooks
  # def create
  #   @webhook = Webhook.new(webhook_params)
  #
  #   if @webhook.save
  #     render json: @webhook, status: :created, location: @webhook
  #   else
  #     render json: @webhook.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # PATCH/PUT /webhooks/1
  # def update
  #   if @webhook.update(webhook_params)
  #     render json: @webhook
  #   else
  #     render json: @webhook.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /webhooks/1
  # def destroy
  #   @webhook.destroy
  # end
  #
  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_webhook
  #     @webhook = Webhook.find(params[:id])
  #   end
  #
  #   # Only allow a trusted parameter "white list" through.
  #   def webhook_params
  #     params.require(:webhook).permit(:webhook_id, :payload)
  #   end
end
