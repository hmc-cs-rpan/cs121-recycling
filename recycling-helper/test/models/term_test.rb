require 'test_helper'

class TermTest < ActiveSupport::TestCase
  properties_for Term, required: [:name, :definition]

  test "cannot create duplicate terms" do
    term = Term.all[0]

    assert_raise ActiveRecord::RecordNotUnique do
      # Definition can be whatever, this should still fail
      Term.create(name: term.name, definition: 'blah blah blah blah blah')
    end
  end
end
