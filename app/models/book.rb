class Book < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :category

  has_one_attached :image
  validates :image, presence: true

  def image_url
    rails_blob_url(self.image, only_path: true) if self.image.attached?
  end
end
