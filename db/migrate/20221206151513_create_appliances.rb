class CreateAppliances < ActiveRecord::Migration[7.0]
  def change
    create_table :appliances do |t|
      t.references :property, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
      add_index :appliances, :name
  end
end
