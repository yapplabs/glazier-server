class CardsController < ApplicationController
  class AuthenticationRequired < StandardError; end

  def show
    private_data = {}

    if current_user.present?
      PaneUserEntry.where(pane_id: params[:pane_id], github_id: current_user[:github_id]).each do |card_entry|
        private_data[card_entry.key] = card_entry.value
      end
    end

    render json: {card: {"private" => private_data}}
  end
end
