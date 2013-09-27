class DashboardsController < ApplicationController
  def index
    if current_user
      dashboards = current_user.dashboards
    else
      dashboards = default_dashboards
    end
    render json: dashboards.map(&:repository)
  end

  def show
    render json: Dashboard.find_or_bootstrap(params[:id])
  end

  private
  def default_dashboards
    Dashboard.where(
      Dashboard.arel_table[:repository].in(
        ['yapplabs/glazier', 'emberjs/ember.js']
      )
    ).all
  end
end
