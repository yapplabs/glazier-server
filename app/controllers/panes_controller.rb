class PanesController < ApplicationController
  before_filter :authenticate_user, only: [:create]

  def index
    if params[:ids].blank?
      head status: 400
      return
    end

    panes = Pane.find(params[:ids])
    render json: panes
  end

  def create
    pane_id = params[:pane][:id]
    dashboard_id = params[:pane][:dashboard_id]
    pane_type_id = params[:pane][:pane_type_id]

    begin
      dashboard = current_user.dashboards.find(dashboard_id)
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end
    pane = dashboard.add_pane(pane_type_id, pane_id)

    render json: pane
  end
end
