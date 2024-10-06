class AddUserIdToAppliances < ActiveRecord::Migration[7.0]
  def change
    add_column :appliances, :user_id, :integer
  end
end
