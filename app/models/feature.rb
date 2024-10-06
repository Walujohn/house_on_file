class Feature < ApplicationRecord
  belongs_to :space
    
  validates :name, presence: true
#  validates :variety, inclusion: { in: -> record { record.varieties.keys }, allow_blank: true },
#                      presence: { if: -> record { record.varieties.present? } } 
#  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
#  validates :unit_price, numericality: { greater_than: 0 }

#  feature.space.property
#  feature.property
  delegate :property, to: :space
    
  VARIETIES = { "wall covering" => ["paint", "tile", "wood", "wallpaper", "bamboo", "other"], 
                "floor covering" => ["carpet", "concrete", "tile", "wood", "stone", "linoleum", "laminate", "vinyl", "other"], 
                "ceiling covering" => ["paint", "bamboo", "tile", "other"],
                "counter tops" => ["soapstone", "quartz", "recycled glass", "laminate", "tile", "concrete butcher block", "stainless steel", "bamboo", "marble", "other"],
                "trim" => ["crown", "baseboard", "decorative", "other"],
                "cabinets" => ["wood", "faux wood", "paint", "stain", "other"],
                "windows" => ["vinyl", "wood", "aluminum", "paint", "stain", "iron", "plastic", "other"]
      }
    
#  these are for associating with the VARIETIES hash    
  def names 
    { "wall covering" => "wall covering", 
      "floor covering" => "floor covering", 
      "ceiling covering" => "ceiling covering", 
      "counter tops" => "counter tops", 
      "trim" => "trim", 
      "cabinets" => "cabinets", 
      "windows" => "windows" }
  end
  
  def varieties(name)
    VARIETIES["#{name}"]
  end
end
