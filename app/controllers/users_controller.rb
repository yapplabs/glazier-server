class UsersController < ApplicationController
  def show
    if current_user.id != params[:id]
      return head :403
    end
    render json: current_user
  end
end
