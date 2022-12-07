class Appliance < ApplicationRecord
  belongs_to :property
  has_many :appliance_features, dependent: :destroy

  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }
    
  def previous_appliance
      property.appliances.ordered.where("name < ?", name).last
  end
end
