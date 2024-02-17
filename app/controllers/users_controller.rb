class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:index, :destroy]
  before_action :find_user, only: [:destroy]

  def index
    @users = User.all
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully!'
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
