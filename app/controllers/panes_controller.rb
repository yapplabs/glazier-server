class PanesController < ApplicationController
  def index
    if params[:ids].blank?
      head status: 400
      return
    end

    panes = Pane.find(params[:ids])
    render json: panes
  end
end
