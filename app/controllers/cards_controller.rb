class CardsController < ApplicationController
  class InvalidAccessParam < StandardError; end
  class AuthenticationRequired < StandardError; end

  before_filter :authenticate_user, except: :show

  def update_user_data
    CardEntry.transaction do
      params[:data].each do |key, value|
        CardEntry.add_or_update(
          access: params[:access],
          card_id: params[:card_id],
          user_id: current_user.id,
          key: key,
          value: value
        )
      end
    end
  end

  def show
    private_data = {}

    if current_user.present?
      CardEntry.where(card_id: params[:card_id], user_id: current_user.id, access: 'private').each do |card_entry|
        private_data[card_entry.key] = card_entry.value
      end
    end

    # CardEntry.where(card_id: params[:card_id], access: 'public').each do |card_entry|
    #   public_data...
    # end

    render json: {card: {"private" => private_data}}
  end

  def remove_user_data
    raise InvalidAccessParam unless CardEntry.valid_access_type? params[:access]

    card_entry = CardEntry.where(params.slice(:card_id, :user_id, :key, :access)).first
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

  def current_user
    User.find(session[:user_id])
  end
end
