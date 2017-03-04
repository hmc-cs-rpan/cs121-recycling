class City < ApplicationRecord
  validates :name, :state, :zip, presence: true
  validates :zip, format: { with: /\A\d{5}(-\d{4})?\z/, message: 'is not a valid zip code' }
  validates :state, state: true, if: 'state.present?'
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

  # A transformation that takes various alternative formattings and their USPS counterparts to the
  # same string. For example, "Coeur d'Alene" will map to the same string as "COEUR D ALENE"
  def self.format(city)
    city.gsub(/[^a-zA-Z]/, ' ').gsub(/\s+/, ' ').upcase.strip
  end

private

  def validate_location?
    errors.empty?
  end

  # Query the USPS registry to determine whether this city's combination of name, state, and zip
  # code correspond to that of a real city. If this fails, it will do so in one of the following
  # ways:
  #   * fail to connect to the USPS server (base: :usps_error)
  #   * received an HTTP error in the response from the USPS server (base: :usps_error)
  #   * received unexpected/unparseable response (base: :usps_error)
  #   * received a response indicating that the ZIP code does not correspond to any known US city
  #       (zip: :unkown)
  #   * received a response indicating that the ZIP code belongs to a different city
  #       (base: :unknown) and (zip: :invalid)
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
      return
    end

    unless res.code == 200
      errors.add(:base, :usps_error, message: "could not be validated at this time (#{code})")
      return
    end

    begin
      data = Hash.from_xml(res.to_s)
    rescue REXML::ParseException
      errors.add(:base, :usps_error, message: 'could not be validated at this time')
      return
    end

    zip_response = data.dig('CityStateLookupResponse', 'ZipCode')
    unless zip_response
      errors.add(:base, :usps_error, message: 'could not be validated at this time')
      return
    end

    if zip_response['Error']
      errors.add(:zip, :unknown, message: zip_response['Error']['Description'])
    elsif zip_response['City'] && zip_response['State']
      actual_city = zip_response['City']
      actual_state = zip_response['State']
      if City.format(actual_city) != City.format(name) || actual_state != Geography.state_abbreviation(state)
        errors.add(:base, :unknown, message: 'is not a US city')
        errors.add(:zip, :invalid, message:
          "is registered to #{City.format(actual_city)}, #{actual_state}, " +
          "not #{City.format(name)}, #{Geography.state_abbreviation(state)}")
      end
    else
      errors.add(:base, :usps_error, message: "could not be validated at this time')")
    end

  end

end
