class AddAddressToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :address, :string
  end
end
