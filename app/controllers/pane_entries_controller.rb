class PaneEntriesController < ApplicationController
  before_filter :authenticate_user

  def update
    pane = Pane.find(params[:pane_id])

    head :unauthorized unless current_user.has_dashboard?(pane.repository)

    pane.set_entries(params[:data])

    head :no_content
  end

  def destroy
    pane = Pane.find(params[:pane_id])

    head :unauthorized unless current_user.has_dashboard?(pane.repository)

    pane.remove_entry(params[:key])

    head :no_content
  end
end
