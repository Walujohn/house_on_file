class AddZipToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :zip, :integer
  end
end
