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
    user = User.new(name: params[:name], email_address: params[:email],
                    password_digest: params[:password],
                    password_digest_confirmation: params[:password_confirmation])
    user.approvals[:approved_courses] = session[:approved_courses]
    user.approvals[:approved_exams] = session[:approved_exams]
    if user.valid?(:account_create) and user.save
      session[:user_id] = user.id
      session[:approved_courses] = nil
      session[:approved_exams] = nil
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al crear el usuario"
      redirect_to new_account_path
    end
  end

  def create_callback
    google_identity = GoogleSignIn::Identity.new(flash[:google_sign_in]["id_token"])
    user = User.new(name: google_identity.name, email_address: google_identity.email_address,
                    avatar_url: google_identity.avatar_url)
    user.approvals[:approved_courses] = session[:approved_courses]
    user.approvals[:approved_exams] = session[:approved_exams]
    if user.save
      session[:user_id] = user.id
      session[:approved_courses] = nil
      session[:approved_exams] = nil
      redirect_to root_path
    else
      flash[:error] = "Ocurrió un error al crear el usuario"
      redirect_to new_account_path
    end
  end
end
