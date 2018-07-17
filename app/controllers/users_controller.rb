class UsersController < ApplicationController
  before_action :load_user, only: [:edit, :update, :show, :destroy]
  before_action :logged_in_user, excpet: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per(Settings.size.item_page)
  end

  def show
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

  def edit;
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".content_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".content_destroy1"
    else
      flash[:warning] = t ".content_destroy2"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by_id params[:id]
    return if @user
    flash[:fail] = t("content_fail")
    redirect_to signup_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".content1"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by_id params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
