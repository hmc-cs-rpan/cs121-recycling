require_dependency 'validators/state_validator.rb'
class City < ApplicationRecord
  validates :name, :state, :location_id, :latitude, :longitude, presence: true
  validates :state, state: true, if: 'state.present?'
  validates :website_url, format: { with: URI.regexp, message: 'is not a valid URL' },
    if: 'website_url.present?'

  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: 'latitude_changed? || longitude_changed?'

  fuzzily_searchable :name, :state

  has_many :zip_codes
  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, -> { distinct }, through: :items
  has_many :officials, class_name: 'CityOfficial', inverse_of: :city

  def self.fuzzy_search(name: nil, state: nil)
    if name && state
      return find_by_fuzzy_name(name) & find_by_fuzzy_state(state)
    elsif name
      return find_by_fuzzy_name(name)
    elsif state
      return find_by_fuzzy_state(state)
    else
      Rails.logger.error 'City::fuzzy_search: name or state must be non-nil'
    end
  end

end
