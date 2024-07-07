# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create EntryPoints
entry_points = EntryPoint.create([{ name: 'A' }, { name: 'B' }, { name: 'C' }])

Vehicle.create([{size: :small}, {size: :medium}, {size: :large}])

# Parking Slots
entry_points.each do |entry_point|
  [
    { size: 'sp', distances: { entry_point.id.to_s => 1 }.to_json, occupied: false },
    { size: 'mp', distances: { entry_point.id.to_s => 2 }.to_json, occupied: false },
    { size: 'lp', distances: { entry_point.id.to_s => 3 }.to_json, occupied: false }
  ].each_with_index do |slot_params, index|
    ParkingSlot.create(
      size: slot_params[:size],
      distances: slot_params[:distances],
      occupied: slot_params[:occupied],
      name: "#{entry_point.name}#{index + 1}"
    )
  end
end
