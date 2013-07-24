class PaneTypesController < ApplicationController
  def index
    render json: PaneType.all
  end
end
