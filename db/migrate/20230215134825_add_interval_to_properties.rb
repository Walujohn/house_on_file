class AddIntervalToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :interval, :integer
  end
end
