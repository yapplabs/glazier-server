class SectionsController < ApplicationController
  def create
    dashboard_id = params[:section][:dashboard_id]
    dashboard = find_editable_dashboard(dashboard_id)
    return head :forbidden unless dashboard.present?

    section = dashboard.add_section(params[:section])
    render json: section
  end

  def update
    section = Section.find(params[:id])

    unless find_editable_dashboard(section.dashboard_id).present?
      return head :forbidden
    end

    section.update_attributes(
      name: params[:section][:name],
      slug: params[:section][:slug]
    )
    render json: section
  end

  def destroy
    section = Section.find(params[:id])

    unless find_editable_dashboard(section.dashboard_id).present?
      return head :forbidden
    end

    section.destroy

    head :ok
  end

private

  def find_editable_dashboard(dashboard_id)
    current_user.dashboards.find_by_repository(dashboard_id)
  end
end
