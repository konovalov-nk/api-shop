class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def forbid
    render json: {}, status: :unauthorized
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :country, :city, :post_code])
    end
end
