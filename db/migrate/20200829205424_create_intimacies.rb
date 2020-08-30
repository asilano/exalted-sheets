class CreateIntimacies < ActiveRecord::Migration[6.0]
  def change
    create_table :intimacies do |t|
      t.references :character, null: false, foreign_key: true
      t.integer :variety
      t.string :name
      t.integer :intensity

      t.timestamps
    end
  end
end
