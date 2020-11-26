class CreateCharms < ActiveRecord::Migration[6.0]
  def change
    create_table :charms do |t|
      t.references :character, null: false, foreign_key: true
      t.string :name
      t.string :ability
      t.integer :variety
      t.string :duration
      t.string :cost
      t.string :keywords
      t.text :effect

      t.timestamps
    end
  end
end
