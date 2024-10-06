class AddLowToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :low, :integer
  end
end
