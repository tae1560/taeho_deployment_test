class TownsController < ApplicationController
  def index
    @towns = Town.all
  end

  def show
    @town = Town.find(params[:id])
  end
end
