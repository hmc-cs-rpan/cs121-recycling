class ZipCode < ApplicationRecord
  validates :name, :city, presence: true
  validates :name, format: { with: /\A\d{5}(-\d{4})?\z/, message: 'is not a valid zip code' },
    if: 'name.present?'

  belongs_to :city
end
