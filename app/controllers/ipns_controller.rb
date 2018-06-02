class IpnsController < ApplicationController
  before_action :forbid
  # before_action :set_ipn, only: [:show, :update, :destroy]

  # # GET /ipns
  # def index
  #   @ipns = Ipn.all
  #
  #   render json: @ipns
  # end
  #
  # # GET /ipns/1
  # def show
  #   render json: @ipn
  # end
  #
  # # POST /ipns
  # def create
  #   @ipn = Ipn.new(ipn_params)
  #
  #   if @ipn.save
  #     render json: @ipn, status: :created, location: @ipn
  #   else
  #     render json: @ipn.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # PATCH/PUT /ipns/1
  # def update
  #   if @ipn.update(ipn_params)
  #     render json: @ipn
  #   else
  #     render json: @ipn.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /ipns/1
  # def destroy
  #   @ipn.destroy
  # end
  #
  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_ipn
  #     @ipn = Ipn.find(params[:id])
  #   end
  #
  #   # Only allow a trusted parameter "white list" through.
  #   def ipn_params
  #     params.require(:ipn).permit(:order_id, :ipn_track_id, :txn_id, :payer_id)
  #   end
end
