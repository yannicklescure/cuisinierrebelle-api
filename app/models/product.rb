class Product < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true
  validates :url, url: true

  mount_uploader :image, PhotoUploader
  mount_uploader :photo, PhotoUploader
end
