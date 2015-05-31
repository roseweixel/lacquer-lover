class StaticPagesController < ApplicationController
  skip_before_action :clear_intended_uri, only: [:welcome]
  
  def welcome
    @user = current_user || User.new
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
      subject = (params[:subject] == "other" ? params[:other_subject] : params[:subject])
      body, to_address = params[:body], params[:to_address]
      params[:bcc] ? bcc = reply_address : bcc = nil
      UserMailer.user_feedback_email(reply_address, to_address, subject, body, bcc).deliver_now
      flash[:success] = "Your message has been sent. Thank you for your feedback!"
      redirect_to(:back)
    end
  end
end
