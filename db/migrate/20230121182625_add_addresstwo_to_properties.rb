class AddAddresstwoToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :addresstwo, :string
  end
end
