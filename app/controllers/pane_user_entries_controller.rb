class PaneUserEntriesController < ApplicationController
  before_filter :authenticate_user
  before_filter :find_pane
  before_filter :verify_data, only: :update

  def update
    @pane.set_user_entries(current_user.github_id, params[:data])
    head :no_content
  end

  def destroy
    @pane.remove_user_entry(current_user.github_id, params[:key])
    head :no_content
  end

private

  def find_pane
    @pane = Pane.find(params[:pane_id])
  end

  def verify_data
    unless params.key?(:data) && params[:data].keys.length >= 1
      render text: 'No data provided', status: :bad_request
    end
  end
end
