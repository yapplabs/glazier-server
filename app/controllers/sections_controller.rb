class SectionsController < ApplicationController
  def create
    dashboard_id = params[:section][:dashboard_id]

    begin
      dashboard = current_user.dashboards.find(dashboard_id)
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end

    section = dashboard.add_section(params[:section])
    render json: section
  end

  def destroy
    section = Section.find(params[:id])

    begin
      current_user.dashboards.find(section.dashboard_id)
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end

    section.destroy

    head :ok
  end
end
