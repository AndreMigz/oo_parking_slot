class VehiclesController < ApplicationController

  def index
    vehicles = Vehicle.all
    render json: { vehicles: vehicles }, status: :ok
  end

  def create
    vehicle = Vehicle.new(vehicle_params)
    if vehicle.save
      render json: { message: 'Vehicle added', vehicle: vehicle }, status: :created
    else
      render json: vehicle.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:size)
  end
end
