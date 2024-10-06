class AddExclusionToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :exclusion, :string
  end
end
