class Space < ApplicationRecord
  belongs_to :property
  has_many :features, dependent: :destroy
    
  validates :name, presence: true
  validates :location, presence: true

  enum :location, interior: 0, exterior: 1
  
  scope :ordered, -> { order(name: :asc) }
    
  scope :containing, -> (query) { where(name: query) }

  CREATED_FEATURES = Array.new

  def previous_space
    property.spaces.ordered.where("name < ?", name).last
  end

  def previous_space_with_list(location)
    spaces = property.spaces.where(location: location)
    spaces.ordered.where("name < ?", name).last
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
    
  def number_the_name(property)
    number = self.name.split(" ").pop.to_i
    if number == 0
      multi_word_matches = property.spaces.select { |space| space.name.delete("0-9").strip == self.name }
#      choose not to number the first of each name for style
      count = multi_word_matches.count unless multi_word_matches.count <= 1
      name = self.name  
      self.name = "#{name}" + " #{count}"
      self.name = self.name.strip
    end
  end
    
  def hand_down_duplicated_features(second_space)
    if self.features.present?
      self.features.each do |feature|
        second_space.features.build(id: self, name: feature.name, variety: feature.variety, description: feature.description, feature_template: feature.id.to_s)
      end
      second_space.save
    end
  end
    
  def collect_class_hash_features
    self.features.each { |f| CREATED_FEATURES << f }
  end
end
