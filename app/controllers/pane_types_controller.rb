class PaneTypesController < ApplicationController
  def index
    render json: PaneType.all
  end

  def show
    render json: PaneType.find(params[:id])
  end
end
