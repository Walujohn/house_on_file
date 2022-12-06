class Feature < ApplicationRecord
  belongs_to :space
    
  validates :name, presence: true
  validates :description, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than: 0 }

#  feature.space.property
#  feature.property
  delegate :property, to: :space
end
