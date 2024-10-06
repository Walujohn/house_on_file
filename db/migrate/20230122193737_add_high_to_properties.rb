class AddHighToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :high, :integer
  end
end
