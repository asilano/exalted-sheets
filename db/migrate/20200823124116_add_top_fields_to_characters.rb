class AddTopFieldsToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :spark, :integer
    add_column :characters, :player_name, :string
    add_column :characters, :caste, :string
    add_column :characters, :concept, :string
    add_column :characters, :anima, :string
    add_column :characters, :supernal, :string
    add_column :characters, :lineage, :string
  end
end
