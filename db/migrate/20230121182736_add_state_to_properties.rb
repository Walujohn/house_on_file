class AddStateToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :state, :string
  end
end
