class DashboardsController < ApplicationController
  def index
    render json: Dashboard.where("repository in ('yapplabs/glazier','emberjs/ember.js')").all
  end

  def show
    render json: Dashboard.find_or_bootstrap(params[:id])
  end
end
