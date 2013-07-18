class UsersController < ApplicationController
  def show
    if current_user.blank?
      head :no_content
      return
    end
    render json: current_user
  end
end
