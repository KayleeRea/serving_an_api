class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end

  def show
    if Car.exists?(params[:id])
    @car = Car.find(params[:id])
      render status: 200
    else
      render json: {}, status: 404
    end
  end
end