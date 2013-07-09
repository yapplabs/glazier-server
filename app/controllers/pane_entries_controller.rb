class PaneEntriesController < ApplicationController
  before_filter :authenticate_user

  def update
    pane = Pane.find(params[:pane_id])
    dashboard = current_user.dashboards.where(
      repository: pane.dashboard.repository
    ).first

    head :unauthorized unless dashboard

    # PaneTypeUserEntry.transaction do
    #   params[:data].each do |key, value|
    #     PaneTypeUserEntry.add_or_update(
    #       pane_type_name: params[:pane_type_name],
    #       github_id: current_user[:github_id],
    #       key: key,
    #       value: value
    #     )
    #   end
    # end
  end

  def destroy
    # card_entry = PaneTypeUserEntry.where(
    #   pane_type_name: params[:pane_type_name],
    #   github_id: current_user[:github_id],
    #   key: params[:key]
    # ).first
    # if card_entry
    #   card_entry.destroy
    # end
    # render json: {}
  end
end
