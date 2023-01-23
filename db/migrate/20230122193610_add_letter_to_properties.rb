class AddLetterToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :letter, :string
  end
end
