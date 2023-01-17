class Space < ApplicationRecord
  belongs_to :property
  has_many :features, dependent: :destroy
    
  validates :name, presence: true

  scope :ordered, -> { order(name: :asc) }
    
  def previous_space
      property.spaces.ordered.where("name < ?", name).last
  end
    
  def duplicate_features(space)
    self.features.each do |f|
      space.features.build(id: space,
                           name: f.name, 
                           variety: f.variety, 
                           description: f.description)
    end
    space.save
  end
end
