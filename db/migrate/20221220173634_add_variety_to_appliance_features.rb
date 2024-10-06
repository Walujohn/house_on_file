class AddVarietyToApplianceFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :appliance_features, :variety, :string
  end
end
