class Category < ApplicationRecord
  validates :name, presence: true
  validates :image_url, format: { with: URI.regexp }, if: 'image_url.present?'

  has_many :items, ->{ order :name }, inverse_of: :category
end
