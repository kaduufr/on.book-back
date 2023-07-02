# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  # before_action :sign_up_params, only: [:create]

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failure
  end

  def register_success
    render json: {
      message: "Signed up successfully.",
      user: current_user
    }

  end

  def register_failure
    puts resource.errors.full_messages
    render json: {
      message: "Something went wrong."
    }, status: :unprocessable_entity
  end



  # protected

  # # If you have extra params to permit, append them to the sanitizer.
  # protected def sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender, :document])
  # end

end
