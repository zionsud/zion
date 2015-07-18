class SessionController < ApplicationController
  def new
    render 'login'
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to(root_url) && return
    end
    redirect_to login_url, alert: 'Usuário ou senha inválidos'
  end

  def destroy
    logout if logged_in?
    redirect_to login_url
  end

  # Show register form to guest
  def register
    @user = User.new
    @wards = Ward.all.order(:name)
  end

  # Add user to database and signin
  def signup
    @user = User.new user_params
    @user.profile = Profile.user

    render(:register) && return unless @user.save

    log_in @user
    redirect_to users_url
  end

  private

  # Permit some user's fields from params
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Permit some person's fields from params
  def person_params
    params.require(:person).permit(
      :name,
      :last_name,
      :nickname,
      :birthday,
      :ward_id,
      :gender
    )
  end
end
