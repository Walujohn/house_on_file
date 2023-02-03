class AddFeatureTemplateToFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :features, :feature_template, :string
  end
end
