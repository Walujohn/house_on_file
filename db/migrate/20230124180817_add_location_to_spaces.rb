class AddLocationToSpaces < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :location, :integer, null: false, default: 0
  end
end
