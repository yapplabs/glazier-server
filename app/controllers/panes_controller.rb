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
    section_id = params[:pane][:section_id]
    pane_type_id = params[:pane][:pane_type_id]
    repository = params[:pane][:repository]
    pane_entries = params[:pane][:pane_entries] || {}

    begin
      section = current_user.sections.find(section_id)
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end

    pane = section.add_pane(pane_type_id, pane_id, position, repository)

    pane_entries.each do |key, value|
      pane_entries[key] = value.to_json
    end
    pane.set_entries(pane_entries)

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
    pane_ids = params.fetch(:pane_ids)
    begin
      section = current_user.sections.find(params.fetch(:section_id))
    rescue ActiveRecord::RecordNotFound
      return head :forbidden
    end
    section.panes.each do |pane|
      new_position = pane_ids.index(pane.id)
      if new_position
        pane.position = new_position
        pane.save! if pane.changed?
      end
    end
    head :no_content
  end
end
