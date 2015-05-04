class StaticPagesController < ApplicationController
  skip_before_action :clear_intended_uri, only: [:welcome]
  def welcome
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end
  end

  def send_feedback_email
    if current_user && params[:reply_address] == current_user.email
      reply_address = "#{current_user.name} <#{params[:reply_address]}>"
    elsif is_an_email_address?(params[:other_reply_address])
      reply_address = params[:other_reply_address]
    end
    if !reply_address
      flash[:alert] = "Your message requires a valid reply address."
      redirect_to :back
    else
      subject, body, to_address = params[:subject], params[:body], params[:to_address]
      params[:bcc] ? bcc = reply_address : bcc = nil
      UserMailer.user_feedback_email(reply_address, to_address, subject, body, bcc).deliver_now
      flash[:success] = "Your message has been sent. Thank you for your feedback!"
      redirect_to(:back)
    end
  end
end
