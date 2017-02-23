class City < ApplicationRecord
  has_many :bins
  has_many :items, through: :bins
  has_many :categories, through: :items
  has_many :officials, class_name: 'CityOfficial'
end
