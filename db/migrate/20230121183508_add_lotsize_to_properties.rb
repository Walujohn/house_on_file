class AddLotsizeToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :lotsize, :string
  end
end
