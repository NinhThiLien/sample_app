class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new;
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(".info")
      redirect_to root_url
    else
      flash.now[:danger] = t(".danger")
      render :new
    end
  end

  def edit;
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t ".flash3"
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit :password, :password_confirmation
    end

    def get_user
      @user = User.find_by email: params[:email]
      return if @user
      flash[:fail] = t("content_fail")
      redirect_to signup_path
    end

    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      return unless @user.password_reset_expired?
      flash[:danger] = t(".danger")
      redirect_to new_password_reset_url
    end
end
