class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum type_user: { user: 0, admin: 1, employee: 2 }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  # validates :type_user, presence: false
  validates :name, presence: true
  validates :document, presence: true
  validates :gender, presence: false
  validates :phone, presence: false
  validates :birth_date, presence: false

  def generate_jwt
    JWT.encode({ id: id,
                 role: type_user,
                 name: name,
                 document: document,
                 exp: 60.days.from_now.to_i },
               Rails.application.credentials.devise[:jwt_secret_key])
  end
end
