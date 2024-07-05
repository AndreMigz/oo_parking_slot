class CreateParkingSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_slots do |t|
      t.integer :size
      t.string :distances
      t.boolean :occupied

      t.timestamps
    end
  end
end
