class PaneEntriesController < ApplicationController
  before_filter :authenticate_user

  def update
    pane = Pane.find(params[:pane_id])

    head :unauthorized unless current_user.has_dashboard?(pane.repository)

    PaneEntry.transaction do
      params[:data].each do |key, value|
        PaneEntry.add_or_update(
          pane_id: pane.id,
          key: key,
          value: value
        )
      end
    end

    head :no_content
  end

  def destroy
    pane = Pane.find(params[:pane_id])

    head :unauthorized unless current_user.has_dashboard?(pane.repository)

    entry = PaneEntry.where(pane_id: pane.id, key: params[:key]).first
    entry.destroy if entry

    head :no_content
  end
end
