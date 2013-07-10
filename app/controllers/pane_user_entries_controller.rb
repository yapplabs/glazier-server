class PaneUserEntriesController < ApplicationController
  before_filter :authenticate_user

  def update
    pane = Pane.find(params[:pane_id])

    pane.set_user_entries(current_user.github_id, params[:data])

    head :no_content
  end

  def destroy
    pane = Pane.find(params[:pane_id])

    pane.remove_user_entry(current_user.github_id, params[:key])

    head :no_content
  end
end
