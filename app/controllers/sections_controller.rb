class SectionsController < ApplicationController
  def index
    sections = Section.find(params[:ids])
    render json: sections
  end

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

    section.update_attributes(params[:section].slice(:name, :slug, :position))
    render json: section
  end

  def update_all
    params[:sections].each do |section_params|
      section = Section.find(section_params[:id])

      unless find_editable_dashboard(section.dashboard_id).present?
        return head :forbidden
      end

      section.update_attributes(section_params.slice(:name, :slug, :position))
    end
    render json: {}
  end

  def destroy
    section = Section.find(params[:id])

    unless find_editable_dashboard(section.dashboard_id).present?
      return head :forbidden
    end

    section.destroy

    render json: {}
  end

private

  def find_editable_dashboard(dashboard_id)
    current_user.dashboards.find_by_repository(dashboard_id)
  end
end
