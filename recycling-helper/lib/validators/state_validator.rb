class StateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Geography.states.include?(value)
      record.errors.add(attribute, :invalid, message: options[:message] || "is not a state")
    end
  end
end
