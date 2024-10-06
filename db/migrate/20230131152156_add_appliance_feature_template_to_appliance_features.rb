class AddApplianceFeatureTemplateToApplianceFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :appliance_features, :appliance_feature_template, :string
  end
end
