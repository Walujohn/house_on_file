class Property < ApplicationRecord
    belongs_to :group
    has_many :spaces, dependent: :destroy
    has_many :features, through: :spaces, dependent: :destroy
    has_many :appliances, dependent: :destroy
    has_many :appliance_features, through: :appliances, dependent: :destroy
    validates :name, presence: true
#    enum :access, publish: 0, draft: 1, passcode_protect: 2
#    has_rich_text :content
#    with_options presence: true do
#      validates :content
#      validates :passcode, if: :passcode_protect?
#    end
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
        "Create 3 bed" => ["bedroom", "bedroom 2", "bedroom 3", "sunroom", 
                           "bathroom", "bathroom 2", "bathroom 3", "stairs", "basement", 
                           "kitchen", "dining room", "living room", "foyer", 
                           "front entrance", "hallway", "office", "yard", "garage"],
        "Create studio apt." => ["kitchen area", "bedroom", "loft", "living room", "bathroom"],
        "Create retail layout" => ["storage", "sales floor", "registers", "entrance", "emergency exit", "office", "family restrooms"],
        "Create town home" => ["kitchen", "bedroom", "bedroom 2", "living room", "media room", "basement", "deck", "patio", "porch"]
        }
    
    APPLIANCES_TEMPLATES = {
        "Create 3 bed" => ["hvac", "refrigerator", "shower tub", "shower tub 2"],
        "Create studio apt." => ["refrigerator", "fireplace", "dryer", "dryer vent"],
        "Create retail layout" => ["commercial HVAC"],
        "Create town home" => ["refrigerator", "shower", "dishwasher"]
        }
    
    FEATURES_TEMPLATES = {  
      "basementOff": { ceiling_covering: { name: "ceiling covering", 
                                        description: "A ceiling covering" }, 
#                                        quantity: 12, 
#                                        unit_price: 3 }, 
          
                    wall_covering: { name: "wall covering", 
                                     description: "A wall covering" }, 
#                                     quantity: 12, 
#                                     unit_price: 3 }, 
          
                    floor_covering: { name: "floor covering", 
                                      description: "A floor covering" }, 
#                                      quantity: 12, 
#                                      unit_price: 3 },
          
                    window: { name: "window", 
                              description: "A window" } 
#                              quantity: 12, 
#                              unit_price: 3 }
          },
        
      "kitchenOff": { ceiling_covering: { name: "ceiling covering", 
                                       description: "A ceiling covering" }, 
#                                       quantity: 12, 
#                                       unit_price: 3 }, 
          
                   wall_covering: { name: "wall covering", 
                                    description: "A wall covering" }, 
#                                    quantity: 12, 
#                                    unit_price: 3 },
          
                   floor_covering: { name: "floor covering", 
                                     description: "A floor covering" } 
#                                     quantity: 12, 
#                                     unit_price: 3 }
          } 
        }
    
    APPLIANCE_FEATURES_TEMPLATES = {
      "commercial HVAC": { 
              single_split_system: { name: "single split system", description: "https://safetyculture.com/topics/hvac-systems/ ...additional parts, such as ductwork, can be incorporated into the system. This helps with better air distribution so the whole commercial space can be cooled or heated at the desired levels." }
              },
      "fireplace": { 
              damper: { name: "damper", description: "Damper closes all the way." },
              chimney_pipe: { name: "chimney pipe", description: "About 32 feet of 5d pipe used to connect."},
              shroud: { name: "shroud", descriptions: "Shroud from K&B Metals Fabrication."},
              apartment_insert_kit: { name: "apartments insert", description: "Fireplace insert used for apartments. I think mantel brand was Wisteria. A log lighter was removed before installing."},
              marble_surround: { name: "marble surround", description: "Marble surround from Inter-Continental Marble Corp" }
              }, 
      "dryer vent": { 
              connector_hose: { name: "connector hose", description: "Used semi-rigid aluminum flex connector hose fastened with metal tape." },
              pipe: { name: "dryer vent pipe", description: "Rigid pipe and 4 elbows used. Cleaned from the roof 2022."}
              } 
        }
    
    CREATED_SPACES = Array.new
    CREATED_APPLIANCES = Array.new
    FEATURE_NAMES = Set.new
    
    DROPDOWNS = ["List interiors", "List exteriors", "List all"]
    
    def styles
      { "List all" => "List all", 
        "List interiors" => "List interiors",
        "List exteriors" => "List exteriors",
          
        "Create town home" => "Town house size starting layer",
        "Line four" => " Remove all unedited spaces and appliances from property and generate 2 bedrooms, kitchen,",
        "Line five" => "living room, media room, basement, deck, patio, porch, refrigerator, shower and dishwasher",

        "Create 3 bed" => "3 bedroom size starting layer", 
        "Line seven" => "Remove all unedited spaces and appliances from property and generate, 3 bedrooms,",  
        "Line eight" => "3 bathrooms, kitchen, dining room, living room, sunroom, stairs, basement, foyer,", 
        "Line nine" => "front entrance, hallway, office, yard, garage, 2 shower tubs, hvac and refrigerator", 
          
        "Create studio apt." => "Studio apt. size starting layer", 
        "Line eleven" => "Remove all unedited spaces and appliances from property and generate a bedroom,", 
        "Line twelve" => "kitchen, loft, living room, bathroom, refrigerator, fireplace, dryer, and dryer vent", 
          
        "Create retail layout" => "Commercial size starting layer",
        "Line fourteen" => "Remove all unedited spaces and appliances from property and generate a storage,",
        "Line fifteen" => "sales floor, registers, entrance, emergency exit, office, restrooms and commercial HVAC",
          
        "Reset canvas" => "Reset canvas/all unedited spaces and appliances" }
    end
    
    def forms
      { "Address" => "Address", "Town houses, shared, apartments" => "Town houses, shared, apartments" }
    end
    
    def list_of_space_names
      %w[attic basement bathroom balcony bedroom closet 
         deck driveway entryway foyer garage hallway kitchen 
         loft livingroom office patio porch pantry stairway sunroom].sort
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
    
    def create_space(property, space, location = "interior")
      @space = property.spaces.build(id: self, name: "#{space}", location: location)
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
                                          description: feature[1][:description])
           @feature.save 
        end  
      end
    end
    
    def create_common_features(space)
      common_features.each do |feature|
        @feature = space.features.build(id: self, 
                                        name: feature)
        @feature.save 
      end  
    end
    
    def common_features
      ["wall covering", "ceiling covering", "floor covering"]
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
      self.features.each { |f| FEATURE_NAMES << f.name }
    end
        
    def create_template_features(space)        
      FEATURE_NAMES.each do |feature| 
        @feature = space.features.build(id: space, 
                                        name: feature, 
                                        description: "The #{space.name} #{feature}")
        @feature.save
      end
    end
    
    def create_class_hash_features(space)
      Space::CREATED_FEATURES.each do |feature|
        @feature = space.features.build(id: space, 
                                        name: feature.name, 
                                        description: feature.description,
                                        feature_template: feature.id.to_s)
        @feature.save
      end
    end
    
    def rollover(space, current_user)
      FEATURE_NAMES.clear
      self.collect_feature_names
      create_template_features(space) unless FEATURE_NAMES.empty?
      space.update(user_id: current_user.id) unless FEATURE_NAMES.empty?
    end
    
    def rollover_property_broadcast_template(space, current_user)
      self.rollover(space, current_user)
      if FEATURE_NAMES.present?
        properties = self.get_associated_properties(self.group)    
    
        if properties.present?
          Space::CREATED_FEATURES.clear
          space.collect_class_hash_features
          properties.each do |property|
            if property.spaces.present?
              selected_space = property.spaces.select { |s| s.space_template == space.id.to_s }
              if selected_space.present?
                property.create_class_hash_features(selected_space.first) unless selected_space.first.features.present?
                selected_space.first.update(user_id: current_user.id)
              end    
            end
          end
        end
      end
    end
    
#    building 'apartments, town houses, shared' with numbers and letters
    def build(params, current_group)
      low = params[:low]
      high = params[:high]
      letters = params[:letter].strip
      self.assign_numbers_and_letters(low, high, letters, current_group)
#      if property_template = params[:property_template]
#        split_property_template(property_template, current_group)   
#      end
    end
    
    def assign_numbers_and_letters(low, high, letters, current_group)
      (low..high).each do |number|
        if letters.empty?
          @property = current_group.properties.build(name: "#{self.name.strip}" + " #{number}", property_template: "#{self.id}") 
          @property.save
        else
          letters.split("").each do |letter| 
            @property = current_group.properties.build(name: "#{self.name.strip}" + " #{number}" + "#{letter}", property_template: "#{self.id}") 
            @property.save
          end         
        end
      end
    end

#    def self.split_property_template(property_template, current_group)
#      property_template.gsub(",","").split(" ").each do |word| 
#        @property = current_group.properties.build(name: "#{word}") 
#        @property.save
#      end
#    end
    
    def get_associated_properties(current_group)
      id_string = self.id.to_s
      properties = current_group.properties.select { |property| property.property_template == id_string }
      properties
    end
    
    def hand_down_duplicate_space_with_features(current_group, space, current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          second_space = property.spaces.build(id: self, name: space.name, location: space.location, space_template: space.id.to_s, user_id: current_user.id)
          second_space.save
          space.hand_down_duplicated_features(second_space)
        end
      end
    end
    
    def hand_down_space(current_group, space, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          s = property.spaces.build(id: self, name: space.name, location: space.location, space_template: space.id.to_s, user_id: user_id)
          s.save
        end
      end
    end
    
    def is_there_a_current_user(current_user)
      if current_user
        user_id = current_user.id
      else
        user_id = nil
      end
    end
    
    def hand_down_appliance(current_group, appliance, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          a = property.appliances.build(id: self, name: appliance.name, appliance_template: appliance.id.to_s, user_id: user_id)
          a.save
        end
      end
    end
    
    def hand_down_feature(current_group, space, feature, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          selected_space = property.spaces.select { |s| s.space_template == space.id.to_s }
          if selected_space.present?            
            f = selected_space.first.features.build(name: feature.name, variety: feature.variety, description: feature.description, feature_template: feature.id.to_s)
            f.save
            selected_space.first.update(user_id: user_id)
          end
        end
      end
    end
    
    def hand_down_appliance_feature(current_group, appliance, appliance_feature, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          selected_appliance = property.appliances.select { |a| a.appliance_template == appliance.id.to_s }
          if selected_appliance.present?    
            af = selected_appliance.first.appliance_features.build(name: appliance_feature.name, description: appliance_feature.description, appliance_feature_template: appliance_feature.id.to_s)
            af.save
            selected_appliance.first.update(user_id: user_id)
          end
        end
      end
    end
    
    def hand_down_destroy_space(current_group, space)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.spaces.present?
            property.spaces.each do |s| 
              if s.space_template == space.id.to_s 
                s.destroy unless s.user_id
              end
            end
          end
        end
      end
    end
    
    def hand_down_destroy_appliance(current_group, appliance)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.appliances.present?
            property.appliances.each do |a| 
              if a.appliance_template == appliance.id.to_s 
                a.destroy unless a.user_id
              end
            end
          end
        end
      end
    end
    
    def hand_down_feature_destroy(current_group, feature)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          selected_feature = property.features.select { |f| f.feature_template == feature.id.to_s }
          if selected_feature.present?
            selected_feature.first.destroy unless selected_feature.first.user_id
          end
        end
      end
    end
    
    def hand_down_appliance_feature_destroy(current_group, appliance_feature)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          selected_appliance_feature = property.appliance_features.select { |f| f.appliance_feature_template == appliance_feature.id.to_s }
          if selected_appliance_feature.present?
            selected_appliance_feature.first.destroy unless selected_appliance_feature.first.user_id
          end
        end
      end
    end
    
    def hand_down_update_space(current_group, space, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.spaces.present?
            property.spaces.each do |s| 
              if s.space_template == space.id.to_s 
                s.update(name: space.name, location: space.location, user_id: user_id)
              end
            end
          end
        end
      end
    end
    
    def hand_down_appliance_update(current_group, appliance, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.appliances.present?
            property.appliances.each do |a| 
              if a.appliance_template == appliance.id.to_s 
                a.update(name: appliance.name, user_id: user_id)
              end
            end
          end
        end
      end
    end
    
    def hand_down_feature_update(current_group, feature, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.features.present?
            selected_feature = property.features.select { |f| f.feature_template == feature.id.to_s }
            if selected_feature.present?
              selected_feature.first.update(name: feature.name, variety: feature.variety, description: feature.description)
              selected_feature.first.space.update(user_id: user_id)
            end
          end
        end
      end
    end
    
    def hand_down_appliance_feature_update(current_group, appliance_feature, current_user = nil)
      user_id = is_there_a_current_user(current_user)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          if property.appliance_features.present?
            selected_appliance_feature = property.appliance_features.select { |af| af.appliance_feature_template == appliance_feature.id.to_s }
            if selected_appliance_feature.present?
              selected_appliance_feature.first.update(name: appliance_feature.name, description: appliance_feature.description)
              selected_appliance_feature.first.appliance.update(user_id: user_id)
            end
          end
        end
      end
    end
    
    def reset_template
      self.spaces.each { |space| space.destroy unless space.user_id }
      self.appliances.each { |appliance| appliance.destroy unless appliance.user_id }
    end
    
    def respond_to_dropdown(dropdown_name, current_group)
      if SPACES_TEMPLATES.keys.include?(dropdown_name) and self.property_template.blank?
        self.reset_template
        self.define_template(dropdown_name)
      elsif SPACES_TEMPLATES.keys.include?(dropdown_name) and self.property_template and self.property_template.to_i != 0
        self.reset_template
        self.define_template(dropdown_name)
#     if this is a broadcasting templater property then 'broadcast' the dropdown response
      elsif SPACES_TEMPLATES.keys.include?(dropdown_name) and self.property_template and self.property_template.to_i == 0
        self.reset_template
        self.broadcast_the_reset(current_group)
        self.define_template(dropdown_name)
        self.broadcast_response_to_dropdown(current_group)
#     if this is a broadcasting templater property then 'broadcast' the dropdown response
      elsif dropdown_name == "Reset canvas" and self.property_template and self.property_template.to_i == 0
        self.reset_template
        self.broadcast_the_reset(current_group)
      else
        self.reset_template
      end
    end
    
    def broadcast_the_reset(current_group)
      properties = self.get_associated_properties(current_group)
      if properties.present?
        properties.each do |property|
          property.reset_template 
        end
      end
    end
    
    def broadcast_response_to_dropdown(current_group) 
      self.broadcast_response_to_dropdown_spaces(current_group)
      self.broadcast_response_to_dropdown_appliances(current_group)
      self.broadcast_response_to_dropdown_features(current_group)
      self.broadcast_response_to_dropdown_appliance_features (current_group)
    end
    
    def broadcast_response_to_dropdown_spaces(current_group)
      CREATED_SPACES.each do |space|
        self.hand_down_space(current_group, space) 
      end
    end
    
    def broadcast_response_to_dropdown_appliances(current_group)
      CREATED_APPLIANCES.each do |appliance|
        self.hand_down_appliance(current_group, appliance)
      end
    end
    
    def broadcast_response_to_dropdown_features(current_group)
      CREATED_SPACES.each do |space|
        if space.features
          space.features.each do |feature|
            self.hand_down_feature(current_group, space, feature)
          end
        end
      end
    end
    
    def broadcast_response_to_dropdown_appliance_features (current_group)
      CREATED_APPLIANCES.each do |appliance|
        if appliance.appliance_features
          appliance.appliance_features.each do |appliance_feature|
            self.hand_down_appliance_feature(current_group, appliance, appliance_feature)
          end
        end
      end
    end
    
    def broadcast_user_id(current_group)
    end
    
    def associated_count (current_group)
      properties = self.get_associated_properties(current_group)
      properties.count
    end
end