class AddCountryToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :country, :string
  end
end
