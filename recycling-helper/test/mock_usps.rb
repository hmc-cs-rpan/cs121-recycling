class MockUsps

  def initialize(stub)
    @stub = stub
  end

  def self.valid_cities
    [
      { name: 'Claremont', state: 'California', zip: '91711' },
      { name: 'Cashiers', state: 'North Carolina', zip: '28717' }
    ]
  end

  # Note: for the mock API to work properly, every invalid city in here most have a zip code that
  # is listed somewhere in the valid cities
  def self.invalid_cities
    [
      { name: 'Claremont', state: 'California', zip: '28717' },     # 28717 is Cashiers, NC
      { name: 'Claremont', state: 'North Carolina', zip: '91711' }, # Claremont is in CA
      { name: 'Claremont', state: 'North Carolina', zip: '28717' }
    ]
  end

  def stub(method = :any, path = '')
    @stub.stub_request(method,
      /#{Regexp.quote('production.shippingapis.com/ShippingAPI.dll')}#{path}/)
  end

  def stub_recursive(method = :any, path = '')
    stub(method, path + '.*')
  end

  def stub_all
    stub(:get)
      .with(query: @stub.hash_including({'API' => 'CityStateLookup'}))
      .to_return do |request|
        data = Addressable::URI.parse(request.uri).query_values
        data['XML'] ? city_state_lookup(Hash.from_xml(data['XML']))
                    : error_parse_query('CityStateLookup')
      end
  end

  def error_parse_query(api)
    {
      status: 200,
      body: {
        'Number' => '80040B19',
        'Description' => 'XML Syntax Error: Please check the XML request to see if it can be parsed.'
      }.to_xml(root: 'Error')
    }
  end

  def error_invalid_user(api)
    {
      status: 400,
      body: "<html><body><b>Http/1.1 Bad Request</b></body></html>"
    }
  end

  def error_invalid_zip_code(api)
    {
      status: 200,
      body: {
        'ZipCode' => {
          'Error' => {
            'Number' => '-2147219399',
            'Source' => 'WebtoolsAMS;CityStateLookup',
            'Description' => 'Invalid Zip Code.'
          }
        }
      }.to_xml(root: "#{api}Response")
    }
  end

  def city_state_lookup(xml)
    unless xml.dig('CityStateLookupRequest','USERID') == Rails.application.secrets.usps_api_key
      return error_validate_user('CityStateLookup')
    end

    zip = xml.dig('CityStateLookupRequest', 'ZipCode', 'Zip5')
    unless zip
      return error_invalid_zip_code('CityStateLookup')
    end

    loc = MockUsps.valid_cities.find do |valid_loc|
      valid_loc[:zip] == zip
    end

    unless loc
      return error_invalid_zip_code('CityStateLookup')
    end

    # This zip code corresponds to a valid location
    return {
      status: 200,
      body: {
        'ZipCode' => {
          'City' => loc[:name],
          'State' => Geography.state_abbreviation(loc[:state])
        }
      }.to_xml(root: 'CityStateLookupResponse')
    }
  end

end
