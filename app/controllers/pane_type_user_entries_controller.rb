class PaneTypeUserEntriesController < ApplicationController
  class AuthenticationRequired < StandardError; end

  before_filter :authenticate_user, except: :show

  def update
    PaneTypeUserEntry.transaction do
      params[:data].each do |key, value|
        PaneTypeUserEntry.add_or_update(
          pane_type_name: params[:pane_type_name],
          github_id: current_user[:github_id],
          key: key,
          value: value
        )
      end
    end
  end

  def destroy
    card_entry = PaneTypeUserEntry.where(
      pane_type_name: params[:pane_type_name],
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
      raise AuthenticationRequired
    end
  end
end
