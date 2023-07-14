class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find({ type => "user"})
    render json: UserRepresenter.new(user).as_json
  end

  private

  def get_user_from_token
    token = request.headers["Authorization"].split(" ")[1]
    decoded_token = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, { algorithm: "HS256" })
    user_id = decoded_token.first["sub"]
    User.find(user_id.to_s)
  end

  # Terminar esse endpoint de buscar todos os livros que o usuario ja pegou emprestado

  def get_all_books_borrowed
    @books_borrowed = BookBorrow.where(user_id: current_user.id)
  end

end
