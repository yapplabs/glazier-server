class PanesController < ApplicationController
  before_filter :authenticate_user, only: [:create, :destroy]

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
    position = params[:pane][:position]
    dashboard_id = params[:pane][:dashboard_id]
    pane_type_id = params[:pane][:pane_type_id]
    repository = params[:pane][:repository]

    begin
      dashboard = current_user.dashboards.find(dashboard_id)
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end
    pane = dashboard.add_pane(pane_type_id, pane_id, position, repository)

    render json: pane
  end

  def destroy
    pane_id = params[:id]
    pane = Pane.find(pane_id)

    head :forbidden unless current_user.has_dashboard?(pane.repository)

    pane.destroy()

    head :no_content
  end

  def reorder
    pane_ids = params[:pane_ids]
    begin
      dashboard = current_user.dashboards.find(params[:dashboard_id])
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end
    dashboard.panes.each do |pane|
      new_position = pane_ids.index(pane.id)
      if new_position
        pane.position = new_position
        pane.save! if pane.changed?
      end
    end
    head :no_content
  end
end
