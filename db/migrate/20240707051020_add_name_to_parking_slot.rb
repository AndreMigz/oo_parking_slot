class AddNameToParkingSlot < ActiveRecord::Migration[7.1]
  def change
    add_column :parking_slots, :name, :string
  end
end
