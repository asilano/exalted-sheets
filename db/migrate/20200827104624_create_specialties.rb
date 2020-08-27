class CreateSpecialties < ActiveRecord::Migration[6.0]
  def change
    create_table :specialties do |t|
      t.references :character, null: false, foreign_key: true
      t.string :ability
      t.string :situation

      t.timestamps
    end
  end
end
