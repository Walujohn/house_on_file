class Property < ApplicationRecord
    belongs_to :group
    has_many :spaces, dependent: :destroy
    has_many :features, through: :spaces
    has_many :appliances, dependent: :destroy
    has_many :appliance_features, through: :appliances
    
    validates :name, presence: true
    
    scope :ordered, -> { order(id: :desc) }
    
#    the next two lines are the same
#    after_create_commit -> { broadcast_prepend_to "properties", partial: "properties/property", locals: { property: self }, target: "properties" }
#    after_create_commit -> { broadcast_prepend_later_to "properties" }
#    after_update_commit -> { broadcast_replace_later_to "properties" }
#    after_destroy_commit -> { broadcast_remove_to "properties" }
#    Those three callbacks are equivalent to the following single line
#    broadcasts_to ->(property) { "properties" }, inserts_by: :prepend
    
    broadcasts_to ->(property) { [property.group, "properties"] }, inserts_by: :prepend
    
    FEATURES_TEMPLATES = {  
          "basement": { 
              ceiling_covering: { name: "ceiling covering", description: "A ceiling covering", quantity: 12, unit_price: 3 }, 
              wall_covering: { name: "wall covering", description: "A wall covering", quantity: 12, unit_price: 3 },
              floor_covering: { name: "floor covering", description: "A floor covering", quantity: 12, unit_price: 3 },
              window: { name: "window", description: "A window", quantity: 12, unit_price: 3 }
              },
          "kitchen": { 
              ceiling_covering: { name: "ceiling covering", description: "A ceiling covering", quantity: 12, unit_price: 3 }, 
              wall_covering: { name: "wall covering", description: "A wall covering", quantity: 12, unit_price: 3 },
              floor_covering: { name: "floor covering", description: "A floor covering", quantity: 12, unit_price: 3 }
              } 
        }
    
    APPLIANCE_FEATURES_TEMPLATES = {
           "hvac": { 
              ceiling_covering: { name: "ceiling covering", description: "A ceiling covering", quantity: 12, unit_price: 3 }, 
              wall_covering: { name: "wall covering", description: "A wall covering", quantity: 12, unit_price: 3 },
              floor_covering: { name: "floor covering", description: "A floor covering", quantity: 12, unit_price: 3 },
              window: { name: "window", description: "A window", quantity: 12, unit_price: 3 }
              },
          "refrigerator": { 
              ceiling_covering: { name: "ceiling covering", description: "A ceiling covering", quantity: 12, unit_price: 3 }, 
              wall_covering: { name: "wall covering", description: "A wall covering", quantity: 12, unit_price: 3 },
              floor_covering: { name: "floor covering", description: "A floor covering", quantity: 12, unit_price: 3 }
              } 
        }
    
    CREATED_SPACES = Array.new
    
    CREATED_APPLIANCES = Array.new
    
    def total_features
        self.features.count + self.appliance_features.count
    end
    
    def define_template(template)   
      if template = "everything"
        self.create_property_template(everything_template_spaces, everything_template_appliances)
      end
    end
    
    def everything_template_spaces
      ["basement", "kitchen", "bedroom"]
    end
    
    def everything_template_appliances
      ["hvac", "refrigerator"]
    end
    
#    template spaces
    def template_spaces(spaces)
      spaces.each { |space| CREATED_SPACES << create_space(self, space) }
    end
    
    def create_space(property, space)
      @space = property.spaces.build(id: self, name: "#{space}")
      @space.save
      @space
    end
    
    def template_features(created_spaces)
      created_spaces.each { |space| create_features(space) }
    end
    
    def create_features(space)
      if FEATURES_TEMPLATES.include?(:"#{space.name}")     
        FEATURES_TEMPLATES[:"#{space.name}"].each do |feature|
          @feature = space.features.build(id: self, 
                                          name: feature[1][:name], 
                                          description: feature[1][:description], 
                                          quantity: feature[1][:quantity], 
                                          unit_price: feature[1][:unit_price])
           @feature.save 
        end  
      end
    end
    
#    template appliances
    def template_appliances(appliances)
      appliances.each { |appliance| CREATED_APPLIANCES << create_appliance(self, appliance) }
    end
    
    def create_appliance(property, appliance)
      @appliance = property.appliances.build(id: self, name: "#{appliance}")
      @appliance.save
      @appliance
    end
    
    def template_appliance_features(created_appliances)
      created_appliances.each { |appliance| create_appliance_features(appliance) }
    end

    def create_appliance_features(appliance)
      if APPLIANCE_FEATURES_TEMPLATES.include?(:"#{appliance.name}")      
        APPLIANCE_FEATURES_TEMPLATES[:"#{appliance.name}"].each do |appliance_feature|
          @appliance_feature = appliance.appliance_features.build(id: self, 
                                                                  name: appliance_feature[1][:name], 
                                                                  description: appliance_feature[1][:description], 
                                                                  quantity: appliance_feature[1][:quantity], 
                                                                  unit_price: appliance_feature[1][:unit_price])
          @appliance_feature.save 
        end  
      end
    end

    def create_property_template(spaces, appliances)  
      self.template_spaces(spaces)
      self.template_features(CREATED_SPACES)
      self.template_appliances(appliances)
      self.template_appliance_features(CREATED_APPLIANCES)
    end
end
