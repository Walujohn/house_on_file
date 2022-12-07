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
    
    def total_features
        self.features.count + self.appliance_features.count
    end
end
