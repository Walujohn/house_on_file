class AddSquarefootageToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :squarefootage, :integer
  end
end
