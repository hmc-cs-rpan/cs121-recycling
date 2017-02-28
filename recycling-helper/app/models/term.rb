class Term < ApplicationRecord
  validates :name, :definition, presence: true
end
