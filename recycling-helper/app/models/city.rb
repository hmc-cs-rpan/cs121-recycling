require_dependency 'validators/state_validator.rb'
class City < ApplicationRecord
  validates :name, :state, :location_id, presence: true
  validates :state, state: true, if: 'state.present?'
  validates :website_url, format: { with: URI.regexp, message: 'is not a valid URL' },
    if: 'website_url.present?'

  has_many :zip_codes
  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, -> { distinct }, through: :items
  has_many :officials, class_name: 'CityOfficial', inverse_of: :city

  # Add a bin to the city and return the new bin. If the bin is not unique (this city already has
  # a bin by that name) return the existing bin without touching the database.
  def add_bin!(name)
    begin
      result = bins.create(name: name)
    rescue ActiveRecord::RecordNotUnique
      # We already have this bin!
      result = bins.find_by name: name
    end

    result
  end

  # Add a sequence of bins to this city (equivalent to calling add_bin for each listed name).
  # returns a sequence of bins added.
  def add_bins!(*names)
    names.map do |name|
      add_bin!(name)
    end
  end

end
