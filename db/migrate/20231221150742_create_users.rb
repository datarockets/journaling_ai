class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :name
      t.string :last_name
      t.boolean :experience, default: false
      t.string :goals, array: true, default: []

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
