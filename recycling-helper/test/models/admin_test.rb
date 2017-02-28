require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test "can create admin with first name, last name, email, and password" do
    admin = Admin.new(
      first_name: 'John', last_name: 'Doe', email: 'jd@example.com', password: 'password')
    assert admin.save, "failed to create admin: #{admin.errors.full_messages}"
  end

  test "cannot create admin without first name" do
    admin = Admin.new(last_name: 'Doe', email: 'jd@example.com', password: 'password')
    refute admin.save, "created admin without first name"
  end

  test "cannot create admin without last name" do
    admin = Admin.new(first_name: 'John', email: 'jd@example.com', password: 'password')
    refute admin.save, "created admin without last name"
  end
end
