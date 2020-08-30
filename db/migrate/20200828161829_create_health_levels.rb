class CreateHealthLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :health_levels do |t|
      t.references :character, null: false, foreign_key: true
      t.integer :penalty

      t.timestamps
    end
  end
end
