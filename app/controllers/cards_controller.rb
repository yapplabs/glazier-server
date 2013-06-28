class CardsController < ApplicationController
  class AuthenticationRequired < StandardError; end

  before_filter :authenticate_user, except: :show

  def update_user_data
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

  def show
    private_data = {}

    if current_user.present?
      PaneUserEntry.where(pane_id: params[:pane_id], github_id: current_user[:github_id]).each do |card_entry|
        private_data[card_entry.key] = card_entry.value
      end
    end

    render json: {card: {"private" => private_data}}
  end

  def remove_user_data
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
      raise AuthenticationRequired
    end
  end
end
