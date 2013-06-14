class DashboardsController < ApplicationController
  def index
    render json: Dashboard.where("repository in ('yapplabs/glazier','emberjs/ember.js')").all
  end

  def show
    render json: Dashboard.find(params[:id])
  end
end
