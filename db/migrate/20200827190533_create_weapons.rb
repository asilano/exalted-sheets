class CreateWeapons < ActiveRecord::Migration[6.0]
  def change
    create_table :weapons do |t|
      t.references :character, null: false, foreign_key: true
      t.string :name
      t.integer :accuracy
      t.integer :damage
      t.integer :defence
      t.integer :overwhelming
      t.string :tags

      t.timestamps
    end
  end
end
