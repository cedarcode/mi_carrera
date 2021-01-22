class AccountsController < ApplicationController
  def show
    @groups_and_credits = bedel.credits_by_group
    respond_to do |format|
      format.html
    end
  end

  def new
  end

  def create
    user = User.new(
      email_address: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      verified: false,
      approvals: {
        approved_courses: session[:approved_courses],
        approved_exams: session[:approved_exams]
      }
    )
    if user.valid?(:account_create) and user.save
      session[:approved_courses] = nil
      session[:approved_exams] = nil
      VerifyEmailMailer.verify(user).deliver
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al registrarte"
      redirect_to new_account_path
    end
  end

  def create_callback
    google_identity = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.new(
      name: google_identity.name,
      email_address: google_identity.email_address,
      avatar_url: google_identity.avatar_url,
      verified: true,
      approvals: {
        approved_courses: session[:approved_courses],
        approved_exams: session[:approved_exams]
      }
    )
    if user.save
      session[:user_id] = user.id
      session[:approved_courses] = nil
      session[:approved_exams] = nil
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al registrarte"
      redirect_to new_account_path
    end
  end

  def verify_email
    user = User.find_by(id: params[:format])
    session[:user_id] = user.id
    if user.update(verified: true)
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al verificar tu correo electrónico"
      redirect_to root_path
    end
  end
end
