class AddYearbuiltToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :yearbuilt, :integer
  end
end
