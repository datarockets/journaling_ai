class CreateJournalEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :journal_entries do |t|
      t.text :note, null: false
      t.date :entry_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :journal_entries, [:user_id, :entry_date], unique: true
  end
end
