class AddUserIdToApplianceFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :appliance_features, :user_id, :integer
  end
end
