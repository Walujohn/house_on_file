class AddUserIdToSpaces < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :user_id, :integer
  end
end
