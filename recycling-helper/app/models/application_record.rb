class ApplicationRecord < ActiveRecord::Base
  extend Fuzzily::Searchable::Rails4ClassMethods

  self.abstract_class = true
end
