# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by_email(sign_in_params[:email])

    puts user

    if user && user.valid_password?(sign_in_params[:password])
      @current_user = user
      puts @current_user[:type_user]
      successful_login
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private

  def successful_login
    render json: { message: "Login successful." , token: @current_user.generate_jwt }
  end
end
