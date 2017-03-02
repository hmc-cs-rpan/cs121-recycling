ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def valid_url
    'http://www.example.com'
  end

  def invalid_url
    'notaurl'
  end

  def valid_state
    'California'
  end

  def invalid_state
    'Shmorbodia'
  end

  def valid_zip
    '28717'
  end

  def invalid_zip
    '2871'
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
end
