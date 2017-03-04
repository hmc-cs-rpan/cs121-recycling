ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'mock_usps.rb'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Setup mock versions of third party APIs
  setup :stub_apis

  # Provide a list of valid values for the given property, to be used as example data. This creates
  # two instance methods:
  #   valid_#{property}, which returns an arbitrary element from the example values
  #   valid_#{properties}, which returns an array of all provided values
  def self.valid(property, *values)
    define_method('valid_' + property.to_s) do
      values.first
    end
    define_method('valid_' + property.to_s.pluralize(2)) do
      values.flatten
    end
  end

  # Provide a list of invalid values for the given property, to be used as example data. This
  # creates two instance methods:
  #   invalid_#{property}, which returns an arbitrary element from the example values
  #   invalid_#{properties}, which returns an array of all provided values
  def self.invalid(property, *values)
    define_method('invalid_' + property.to_s) do
      values.first
    end
    define_method('invalid_' + property.to_s.pluralize(2)) do
      values.flatten
    end
  end

  # Declare that the given property is really a certain kind of property, but with a special name.
  # For example, to declare that the property :image_url is really a :url (and thus have acces to
  # the valid and invalid url examples via the methods valid_image_url, etc.) you could write:
  #    define_property :image_url, as: :url
  def self.define_property(property, as:)
    define_method('valid_' + property.to_s) do
      public_send('valid_' + as.to_s)
    end
    define_method('valid_' + property.to_s.pluralize(2)) do
      public_send('valid_' + as.to_s.pluralize(2))
    end
    define_method('invalid_' + property.to_s) do
      public_send('invalid_' + as.to_s)
    end
    define_method('invalid_' + property.to_s.pluralize(2)) do
      public_send('invalid_' + as.to_s.pluralize(2))
    end
  end

  def apis
    @apis
  end

  valid :url,
    'http://example.com', 'http://www.example.com', 'http://www.example.edu', 'http://example.org'
  invalid :url, 'www.example.com', 'example.com', 'justplainwrong'

  valid :state, 'California', 'Maryland', 'North Carolina'
  invalid :state, 'notastate'

  valid :zip, '28717', '20817-1411'
  invalid :zip, '2871', '287178', '208171411', '20817-141', '20814-14111'

  # Locations recognized by our USPS API stub
  valid :location, MockUsps.valid_cities
  invalid :location, MockUsps.invalid_cities

  # Run a block with various combinations of valid and invalid properties. Usage:
  #    with_properties valid: :p1, invalid: [:p2, :p3], fixed_property: 'Value' do |props|
  #        assert ...something with props
  #    end
  def with_properties(valid: [], invalid: [], **others)
    valid_properties = Array(valid).map { |prop| examples_of_property(prop, valid: true) }
    invalid_properties = Array(invalid).map { |prop| examples_of_property(prop, valid: false) }

    cartesian_product(valid_properties + invalid_properties).each do |props|
      yield(props.to_h.merge(others))
    end
  end

  # Check that a model can be created with the given properties, and cannot be created without any
  # one of those properties. Usage:
  #    require_properties Model, :property1, :property2, ...
  def self.require_properties_for(model, *properties)
    test "can create #{model} with #{properties.join(', ')}" do
      assert_valid model, default_properties(model, properties)
    end

    properties.each do |property|
      test "cannot create #{model} without #{property}" do
        assert_invalid model, {property => :blank}, default_properties(model, properties).except(property)
      end
    end
  end

  # Check that a model can be created with the given properties. Usage:
  #    assert_valid Model, p1: 'some_property', p2: 'another'
  def assert_valid(model, options = {})
    #instance = model.to_s.classify.constantize.new(options)
    instance = model.new(options)
    assert instance.valid?, "invalid #{model}: #{instance.errors.full_messages}"
  end

  # Check that a model cannot be created with the given properties. Usage:
  #    assert_invalid Model, { p1: [:error1, :error2] }, p1: 'some_property', p2: 'another'
  # or
  #   assert_invalid Model, { p1: :just_one_error }, p1: 'some_property', ...
  def assert_invalid(model, errors, options = {})
    #instance = model.to_s.classify.constantize.new(options)
    instance = model.new(options)
    refute instance.valid?, "model #{model} with properties #{options} is valid"

    errors.each do |property, property_errors|
      # Convert to array if the caller only passed in a single error
      Array(property_errors).each do |error|
        # Try to find the given error in the details. We're looking for a hash with a key :error
        # pointing to a value matching the given error.
        assert instance.errors.details[property].any?{ |detail| detail[:error] == error },
          "did not find expected error \"#{error}\" on property #{property}; " +
          "found errors: #{instance.errors.details}"
      end
    end
  end

private
  # Get an example model for testing
  def typical(model)
    existing = model.all[0]
    assert existing,
      "please create fixtures for #{model} before using the require_properties helper"
    return existing
  end

  # Get valid example values for each property
  def default_properties(model, properties)
    defaults = {}
    example = typical(model)
    properties.each do |p|
      assert example.respond_to?(p), "#{p} does not appear to be a property of #{model}"
      defaults[p] = example.public_send(p)
    end
    return defaults
  end

  def cartesian_product(sets)
    if sets.empty?
      return [[]]
    end

    res = []
    sets.first.each do |elem|
      cartesian_product(sets[1, sets.length]).each do |elems|
        res << [elem] + elems
      end
    end

    return res

  end

  def examples_of_property(prop, valid: true)
    prefix = valid ? 'valid_' : 'invalid_'
    public_send(prefix + prop.to_s.pluralize(2)).map do |property|
        [prop, property]
    end
  end

  def stub_apis
    WebMock.disable_net_connect!(allow_localhost: true)
    @apis = {}

    @apis[:usps] = MockUsps.new(self)
    @apis[:usps].stub_all
  end

end
