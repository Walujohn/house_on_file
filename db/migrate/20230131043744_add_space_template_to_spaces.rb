class AddSpaceTemplateToSpaces < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :space_template, :string
  end
end
