class City < ApplicationRecord
  validates :name, :state, :zip, presence: true
  validates :website_url, format: { with: URI.regexp }, if: 'website_url.present?'

  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, through: :items
  has_many :officials, class_name: 'CityOfficial', inverse_of: :city
end
