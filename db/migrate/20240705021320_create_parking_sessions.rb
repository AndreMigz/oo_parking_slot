class CreateParkingSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_sessions do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :parking_slot, null: false, foreign_key: true
      t.datetime :entry_time
      t.datetime :exit_time

      t.timestamps
    end
  end
end
