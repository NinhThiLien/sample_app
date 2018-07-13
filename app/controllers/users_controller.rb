class UsersController < ApplicationController

  def show
    @user = User.find_by_id params[:id]
    return if @user
      flash[:fail] = t("content_fail")
      redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t("content_success")
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
