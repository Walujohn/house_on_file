class AddGroupReferenceToProperties < ActiveRecord::Migration[7.0]
  def change
    add_reference :properties, :group, null: false, foreign_key: true
  end
end
