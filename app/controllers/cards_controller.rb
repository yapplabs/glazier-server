class CardsController < ApplicationController
  class InvalidAccessParam < StandardError; end

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
    card_entry = CardEntry.where(params.slice(:card_id, :user_id, :key)).first
    if card_entry
      data = {}
      data[card_entry.key] = card_entry.value
      render json: {card: {"private" => data}}
    else
      render json: {card: {"private" => {}}}
    end
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

  # mock
  def current_user
    Struct.new(:id).new
  end
end
