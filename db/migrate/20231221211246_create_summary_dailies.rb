class CreateSummaryDailies < ActiveRecord::Migration[7.1]
  def change
    create_table :summary_dailies do |t|
      t.string :note, null: false
      t.references :journal_entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
