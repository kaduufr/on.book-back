class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  private

  def devise_controller?
    is_a?(DeviseController)
  end

  protected

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender, :document, :phone, :birth_date])
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        puts token
        puts Rails.application.credentials.devise[:jwt_secret_key] + '2222'

        jwt_payload = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key])
        @current_user_id = jwt_payload.first['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      rescue JWT => e
        puts e
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
