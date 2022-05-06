class UsersController < ApplicationController
  before_action :load_user, only: [:show, :update]

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to current_user, notice: "Account has been successfully updated."
    else
      render :show
    end
  end

  private

  def load_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:time_zone)
  end
end