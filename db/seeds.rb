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

# Vehicle.create([{size: :small}, {size: :medium}, {size: :large}])

# # Parking Slots
# entry_points.each do |entry_point|
#   ParkingSlot.create(size: :sp, distances: { entry_point.id.to_s => 1 }.to_json, occupied: false)
#   ParkingSlot.create(size: :mp, distances: { entry_point.id.to_s => 2 }.to_json, occupied: false)
#   ParkingSlot.create(size: :lp, distances: { entry_point.id.to_s => 3 }.to_json, occupied: false)
# end
