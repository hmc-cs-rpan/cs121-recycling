class City < ApplicationRecord
  validates :name, :state, :zip, presence: true
  validates :zip, format: { with: /\A\d{5}(-\d{4})?\z/, message: 'is not a valid zip code' }
  validates :state, state: true
  validates :website_url, format: { with: URI.regexp, message: 'is not a valid URL' },
    if: 'website_url.present?'

  # This is expensive, so we only do it if we haven't already failed a validation
  validate :city_state_zip_must_be_real_location, if: :validate_location?

  has_many :bins, inverse_of: :city
  has_many :items, through: :bins
  has_many :categories, through: :items
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

private

  def validate_location?
    errors.empty?
  end

  def city_state_zip_must_be_real_location
    # Look up the zip code in the USPS registry.
    # See https://www.usps.com/business/web-tools-apis/address-information-api.htm for API docs.
    xml = <<XML
      <CityStateLookupRequest USERID="#{Rails.application.secrets.usps_api_key}">
        <ZipCode ID="0">
          <Zip5>#{zip[0,5]}</Zip5>
        </ZipCode>
      </CityStateLookupRequest>
XML
    params = {
      API: 'CityStateLookup',
      XML: xml
    }

    begin
      res = HTTP::get("http://production.shippingapis.com/ShippingAPI.dll?#{params.to_param}")
    rescue HTTP::ConnectionError
      errors.add(:base, :usps_error, message: 'could not be validated at this time')
    else
      if res.code != 200
        errors.add(:base, :usps_error, message: "could not be validated at this time (#{code})")
      else
        data = Hash.from_xml(res.to_s)

        if data['CityStateLookupResponse']['ZipCode']['Error']
          errors.add(:zip, :unknown, message: 'is not a US zip code')
        else
          actual_city = data['CityStateLookupResponse']['ZipCode']['City'].titleize
          actual_state = data['CityStateLookupResponse']['ZipCode']['State']
          if actual_city != name || actual_state != Geography.state_abbreviation(state)
            errors.add(:base, :unknown, message: 'is not a US city')
            errors.add(:zip, :invalid, message:
              "is registered to #{actual_city}, #{actual_state}, " +
              "not #{name}, #{Geography.state_abbreviation(state)}")
          end
        end

      end
    end
  end

end
