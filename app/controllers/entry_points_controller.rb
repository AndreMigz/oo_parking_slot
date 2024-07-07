class EntryPointsController < ApplicationController

  def index
    entry_points = EntryPoint.all
    render json: { entry_points: entry_points }, status: :ok
  end

  def create
    entry_point  = EntryPoint.new(entry_point_params)
    if entry_point.save
      render json: entry_point, status: :created
    else
      render json: entry_point.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def entry_point_params
    params.require(:entry_point).permit(:name)
  end
end
