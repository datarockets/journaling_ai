class CreateSummaryWeeklies < ActiveRecord::Migration[7.1]
  def change
    create_table :summary_weeklies do |t|
      t.string :note, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
