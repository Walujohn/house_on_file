class Property < ApplicationRecord
    belongs_to :group
    has_many :spaces, dependent: :destroy
    has_many :features, through: :spaces, dependent: :destroy
    has_many :appliances, dependent: :destroy
    has_many :appliance_features, through: :appliances, dependent: :destroy
    
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
    
    SPACES_TEMPLATES = {
        "2 bed" => ["kitchen", "bedroom 1", "bedroom 2"],
        "4 bed" => ["kitchen", "bedroom 1", "bedroom 2", "bedroom 3", "bedroom 4"],
        "Studio apt." => ["kitchen", "bedroom", "loft"],
        "Retail" => ["basement", "sales floor"]
        }
    
    APPLIANCES_TEMPLATES = {
        "2 bed" => ["hvac", "refrigerator"],
        "4 bed" => ["hvac", "refrigerator", "shower tub"],
        "Studio apt." => ["refrigerator"],
        "Retail" => ["dryer vent"]
        }
    
    FEATURES_TEMPLATES = {  
      "basement": { ceiling_covering: { name: "ceiling covering", 
                                        description: "A ceiling covering", 
                                        quantity: 12, 
                                        unit_price: 3 }, 
          
                    wall_covering: { name: "wall covering", 
                                     description: "A wall covering", 
                                     quantity: 12, 
                                     unit_price: 3 }, 
          
                    floor_covering: { name: "floor covering", 
                                      description: "A floor covering", 
                                      quantity: 12, 
                                      unit_price: 3 },
          
                    window: { name: "window", 
                              description: "A window", 
                              quantity: 12, 
                              unit_price: 3 }
          },
        
      "kitchen": { ceiling_covering: { name: "ceiling covering", 
                                       description: "A ceiling covering", 
                                       quantity: 12, 
                                       unit_price: 3 }, 
          
                   wall_covering: { name: "wall covering", 
                                    description: "A wall covering", 
                                    quantity: 12, 
                                    unit_price: 3 },
          
                   floor_covering: { name: "floor covering", 
                                     description: "A floor covering", 
                                     quantity: 12, 
                                     unit_price: 3 }
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
    
    FEATURE_NAMES = Set.new
    
    def styles
      { "wall covering" => "wall covering", "floor covering" => "floor covering", "counter" => "counter" }
    end
    
    def total_features
      self.features.count + self.appliance_features.count
    end
    
    def define_template(template)  
      if we_have_this_template(template)
        self.create_property_template(spaces_templates(template), appliances_templates(template))
      end
    end
    
    def we_have_this_template(template)
      spaces_templates(template) or appliances_templates(template)
    end
            
    def spaces_templates(template)
      SPACES_TEMPLATES["#{template}"]
    end
    
    def appliances_templates(template)
      APPLIANCES_TEMPLATES["#{template}"]
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
      CREATED_SPACES.clear
      CREATED_APPLIANCES.clear
      self.template_spaces(spaces)
      self.template_features(CREATED_SPACES)
      self.template_appliances(appliances)
      self.template_appliance_features(CREATED_APPLIANCES)
    end
    
    def collect_feature_names
      self.features.each {|f| FEATURE_NAMES << f.name}
    end
        
    def create_template_features(space)        
      FEATURE_NAMES.each do |feature| 
        @feature = space.features.build(id: space, 
                                        name: feature, 
                                        description: "The #{space.name} #{feature}")
        @feature.save
      end
    end
    
    def rollover(space)
      FEATURE_NAMES.clear
      self.collect_feature_names
      create_template_features(space)
    end
end
