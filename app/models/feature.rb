class Feature < ApplicationRecord
  belongs_to :space
    
  validates :name, presence: true
#  validates :variety, inclusion: { in: -> record { record.varieties.keys }, allow_blank: true },
#                      presence: { if: -> record { record.varieties.present? } }
  validates :description, presence: true 
#  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
#  validates :unit_price, numericality: { greater_than: 0 }

#  feature.space.property
#  feature.property
  delegate :property, to: :space
    
  VARIETIES = { "wall covering" => ["paint", "wood", "wallpaper"], 
                "floor covering" => ["wood", "concrete", "tile", "slab"], 
                "counter" => ["butcher's block", "wood"] 
      }
    
#  these are for associating with the VARIETIES hash    
  def names 
    { "wall covering" => "wall covering", "floor covering" => "floor covering", "counter" => "counter" }
  end
  
  def varieties(name)
    VARIETIES["#{name}"]
  end
end
