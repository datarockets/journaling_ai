class CreateMoods < ActiveRecord::Migration[7.1]
  def change
    create_table :moods do |t|
      t.integer :score, null: false
      t.references :journal_entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
