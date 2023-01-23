class AddCityToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :city, :string
  end
end
