class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = get_user_from_token
    render json: {
      message: "If you see this, you are logged in.",
      user: user
    }
  end

  private

  def get_user_from_token
    token = request.headers["Authorization"].split(" ")[1]
    decoded_token = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, { algorithm: "HS256" })
    user_id = decoded_token.first["sub"]
    user = User.find(user_id.to_s)
  end

end
