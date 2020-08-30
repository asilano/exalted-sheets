class AddExperienceToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :unspent_xp, :integer
    add_column :characters, :total_xp, :integer
    add_column :characters, :unspent_spark_xp, :integer
    add_column :characters, :total_spark_xp, :integer
  end
end
