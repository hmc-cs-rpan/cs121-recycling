class Item < ApplicationRecord
  validates :name, :category, presence: true

  belongs_to :category
  has_and_belongs_to_many :bins
end
