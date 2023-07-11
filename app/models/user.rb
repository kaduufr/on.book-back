class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum type_user: { user: 0, admin: 1, employee: 2 }
  enum gender_user: { male: 1, female: 2, other: 3 }
  before_save { self.email = email.downcase }
  has_many :book_borrows, dependent: :destroy

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
                 role: self.type_user,
                 name: name,
                 email: self.email,
                 document: document,
                 exp: 60.days.from_now.to_i },
               Rails.application.credentials.devise[:jwt_secret_key])
  end

  def has_book_overdue?
    self.book_borrows.where("due_date < ?", Time.now).count > 0
  end
end
