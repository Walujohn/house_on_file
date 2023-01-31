class AddPropertyTemplateToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :property_template, :string
  end
end
