class PaneTypeUserEntriesController < ApplicationController
  before_filter :authenticate_user

  def update
    pane_type = PaneType.find(params[:pane_type_name])

    pane_type.set_user_entries(current_user.github_id, params[:data])

    head :no_content
  end

  def destroy
    pane_type = PaneType.find(params[:pane_type_name])

    pane_type.remove_user_entry(current_user.github_id, params[:key])

    head :no_content
  end
end
