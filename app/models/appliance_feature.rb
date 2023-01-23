class ApplianceFeature < ApplicationRecord
  belongs_to :appliance
    
  validates :name, presence: true
  validates :description, presence: true
#  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
#  validates :unit_price, numericality: { greater_than: 0 }

#  appliance_feature.appliance.property
#  appliance_feature.appliance.property
  delegate :property, to: :appliance
end
