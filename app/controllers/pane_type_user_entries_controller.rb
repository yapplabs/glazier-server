class PaneTypeUserEntriesController < ApplicationController
  before_filter :authenticate_user
  before_filter :verify_data, only: :update

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

private
  def verify_data
    unless params.key?(:data) && params[:data].keys.length >= 1
      render text: 'No data provided', status: :bad_request
    end
  end
end
