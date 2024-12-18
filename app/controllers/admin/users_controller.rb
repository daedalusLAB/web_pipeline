class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    #user not approved order first
    @users = User.order(approved: :asc)

  end

  def approve
    user = User.find(params[:id])
    if params[:commit] == 'approve'
      user.update(approved: true) # Assummig you have an `approved` attribute in your User model
      AdminMailer.user_approved(user.email).deliver
      redirect_to admin_users_path, notice: 'User approved successfully.'
    elsif params[:commit] == 'disapprove'
      if user.admin?
        redirect_to admin_users_path, alert: 'You cannot disapprove an admin.'
        return
      end
      user.update(approved: false) # Assummig you have an `approved` attribute in your User model
      redirect_to admin_users_path, notice: 'User disapproved successfully.'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to admin_users_path, notice: 'User updated successfully.'
    else
      redirect_to admin_users_path, alert: 'User could not be updated.'
    end
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'Access forbidden.'
    end
  end

  def user_params
    params.require(:user).permit(:commit, :approved, :full_name, :company, :invited_by)
  end

end
