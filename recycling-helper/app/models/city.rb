class City < ApplicationRecord
  validates :name, :state, :zip, presence: true
  validates :zip, format: { with: /\A\d{5}(-\d{4})?\z/, message: 'is not a valid zip code' }
  validates :state, state: true
  validates :website_url, format: { with: URI.regexp, message: 'is not a valid URL' },
    if: 'website_url.present?'

  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, through: :items
  has_many :officials, class_name: 'CityOfficial', inverse_of: :city
end
