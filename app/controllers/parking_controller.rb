class ParkingController < ApplicationController

  def park
    vehicle = Vehicle.find_by(id: params[:vehicle_id])
    entry_point = EntryPoint.find_by(id: params[:entry_point_id])

    if vehicle.present? && entry_point.present?
      service = ParkingService.new(entry_point,vehicle)
      slot = service.park_vehicle

      render json: { slot: slot, status: 'parked' }, status: :ok
    else
      render json: { error: 'Vehicle or entry point not found'}, status: :not_found
    end
  end

  def unpark
    session = ParkingSession.find_by(id: params[:session_id])

    if session.present?
      service = ParkingService.new(nil, nil)
      fee = service.unpark_vehicle(session)

      render json: { parking_fee: fee, status: 'unparked' }, status: :ok
    else
      render json: { error: 'Session not found'}, status: :not_found
    end
  end

end
