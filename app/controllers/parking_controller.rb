class ParkingController < ApplicationController

  def park
    vehicle = Vehicle.find_by(id: params[:vehicle_id])
    entry_point = EntryPoint.find_by(id: params[:entry_point_id])

    if vehicle.present? && entry_point.present?
      service = ParkingService.new(entry_point,vehicle)

      render json: service.park_vehicle
    else
      render json: { error: 'Vehicle or entry point not found'}, status: :not_found
    end
  end

  def unpark
    session = ParkingSession.find_by(id: params[:session_id])

    if session.present?
      service = UnparkingService.new(session)

      render json: service.unpark_vehicle, status: :ok
    else
      render json: { error: 'Session not found'}, status: :not_found
    end
  end
end
