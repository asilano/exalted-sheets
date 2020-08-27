class CreateMerits < ActiveRecord::Migration[6.0]
  def change
    create_table :merits do |t|
      t.references :character, null: false, foreign_key: true
      t.string :name
      t.string :rating

      t.timestamps
    end
  end
end
