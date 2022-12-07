class CreateApplianceFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :appliance_features do |t|
      t.references :appliance, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
