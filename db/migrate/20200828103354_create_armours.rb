class CreateArmours < ActiveRecord::Migration[6.0]
  def change
    create_table :armours do |t|
      t.references :character, null: false, foreign_key: true
      t.string :name
      t.integer :soak
      t.integer :hardness
      t.integer :mobility_penalty
      t.string :tags

      t.timestamps
    end
  end
end
