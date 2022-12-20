class AddVarietyToFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :features, :variety, :string
  end
end
