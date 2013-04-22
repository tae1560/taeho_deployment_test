class TownsController < ApplicationController
  def index
    @towns = Town.all
    #@towns = paginate(:page => params[:page])
  end

  def show
    @town = Town.find(params[:id])
    @houses = @town.houses.order("confirm_date DESC").paginate(:page => params[:page])
  end
end
