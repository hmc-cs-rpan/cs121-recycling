class Item < ApplicationRecord
  validates :name, :category,  presence: true
  # validates_format_of :image, :with => /\A%r{\.(png|jpg|jpeg)$}i\Z/, if: 'image.present?'

  belongs_to :category
  has_and_belongs_to_many :bins


def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end


end
