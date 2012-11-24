class PasswordResetsController < ApplicationController
  before_filter :set_host_from_request, only: [:create]
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: "Email sent with password reset instructions"
  end
  
  private
  def set_host_from_request
    ActionMailer::Base.default_url_options = { host: request.host_with_port }
  end
end
