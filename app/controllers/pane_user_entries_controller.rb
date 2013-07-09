class PaneUserEntriesController < ApplicationController
  before_filter :authenticate_user, except: :show

  def update
    PaneUserEntry.transaction do
      params[:data].each do |key, value|
        PaneUserEntry.add_or_update(
          pane_id: params[:pane_id],
          github_id: current_user[:github_id],
          key: key,
          value: value
        )
      end
    end
  end

  def destroy
    card_entry = PaneUserEntry.where(
      pane_id: params[:pane_id],
      github_id: current_user[:github_id],
      key: params[:key]
    ).first
    if card_entry
      card_entry.destroy
    end
    render json: {}
  end

private

  def authenticate_user
    unless current_user.present?
      head :unauthorized
    end
  end
end
