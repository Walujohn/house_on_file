class AddApplianceTemplateToAppliances < ActiveRecord::Migration[7.0]
  def change
    add_column :appliances, :appliance_template, :string
  end
end
