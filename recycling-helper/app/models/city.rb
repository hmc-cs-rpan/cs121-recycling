require_dependency 'validators/state_validator.rb'
class City < ApplicationRecord
  validates :name, :state, :location_id, :latitude, :longitude, presence: true
  validates :state, state: true, if: 'state.present?'
  validates :website_url, format: { with: URI.regexp, message: 'is not a valid URL' },
    if: 'website_url.present?'

  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: 'latitude_changed? || longitude_changed?'

  has_many :zip_codes
  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, -> { distinct }, through: :items
  has_many :officials, class_name: 'CityOfficial', inverse_of: :city
end
