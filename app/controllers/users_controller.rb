class UsersController < ApplicationController
  def index
    if current_user
      @user = current_user
      @users = User.all
    else
      flash[:notice] = "Please sign in to continue!"
      redirect_to root_path
    end
  end

  def live_notifications
    @user = User.find(params[:id])
    respond_to do |format|
      format.js { }
    end
  end

  def user_lacquers
    @transaction = Transaction.new
    @user_lacquer = UserLacquer.find(params[:id])
    @user = User.find(params[:user_id])
    @favorite = Favorite.find_by(lacquer_id: @user_lacquer.lacquer_id, user_id: @user.id)
    respond_to do |format|
      format.js { }
    end
  end

  def show
    if current_user
      [{"OPI" => [@new_opi_lacquer, @opi_lacquers]}, {"Essie" => [@new_essie_lacquer, @essie_lacquers]}, {"Butter London" => [@new_butter_lacquer, @butter_lacquers]}, {"Deborah Lippmann" => [@new_deborah_lacquer, @deborah_lacquers]}].each do |brand_hash|
        brand_hash.each do |brand, variables|
          if !Brand.where(name: brand).empty?
            variables[0] = Brand.where(name: brand).first.lacquers.new
            variables[1] = Brand.where(name: brand).first.lacquers        
          end
        end
      end
      @new_user_lacquer = UserLacquer.new
      @user = User.find(params[:id])
      @friends = @user.friends
      @friendship = current_user.friendships.new(friend: @user)
      @transaction = Transaction.new

      @user_lacquers = @user.user_lacquers.order("updated_at desc")
      
      respond_to do |format|
        format.js
        format.html
        format.json
      end
    else
      if request.env['REQUEST_URI']
        session[:intended_uri] = request.env['REQUEST_URI']
        @user = User.find(params[:id])
        flash[:notice] = %Q[ #{ view_context.link_to("Sign in", login_path, id:"brand-show-sign-in", class:'light-blue-link')} to view #{@user.name}'s profile! ]
        flash[:html_safe] = true
      else
        flash[:notice] = "Please sign in to continue!"
      end
      redirect_to root_path
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Thanks! Your info has been saved."
    else
      flash[:notice] = "Uh oh, something went wrong."
    end
    redirect_to :back
  end

  def search
    if !current_user
      flash[:notice] = "Please sign in to search for lacquer lovers!"
      redirect_to root_path
    else
      @search_term = params[:search_term]
      @results = User.where("lower(name) = ?", params[:search_term].downcase)
      if @results.empty?
        @results = User.where("lower(email) = ?", params[:search_term].downcase)
      end
      render :search_results
    end
  end

  def new_invite
    if !current_user
      session[:intended_uri] = request.env['REQUEST_URI']
      flash[:notice] = %Q[ #{ view_context.link_to("Sign in", login_path, id:"brand-show-sign-in", class:'light-blue-link')} to start inviting friends! ]
      flash[:html_safe] = true
      redirect_to root_path
    end
  end

  def invite_friends
    if !current_user
      flash[:alert] = "You need to be logged in to invite friends!"
      redirect_to(:back)
    else
      @user = current_user
      @emails = params[:emails][0].split(/[\W\s]{2,}/).uniq
      if @user && @emails.any?
        UserMailer.invite_email(@user, @emails).deliver
        if @emails.count > 1
          flash[:success] = "You've successfully sent invitations to #{@emails.to_sentence}!"
        else
          flash[:success] = "You've successfully sent an invitation to #{@emails[0]}!"
        end
      else
        flash[:warning] = "Sorry, there was a problem sending your email invitations!"
      end
      redirect_to(:back)
    end
  end

  def new_transactional_message
    if !current_user
      if request.env['REQUEST_URI']
        session[:intended_uri] = request.env['REQUEST_URI']
        flash[:notice] = %Q[ #{ view_context.link_to("Sign in", login_path, id:"brand-show-sign-in", class:'light-blue-link')} to send a message! ]
        flash[:html_safe] = true
      else
        flash[:notice] = "Please sign in to continue!"
      end
      redirect_to root_path
    else
      if params[:transaction_id]
        @transaction = Transaction.find(params[:transaction_id])
      elsif params[:gift_id]
        @transaction = Gift.find(params[:gift_id])
      end
      @user = current_user
      if @transaction.requester_id == current_user.id
        @other_user = User.find(@transaction.owner.id)
      else
        @other_user = User.find(@transaction.requester_id)
      end
      if @transaction.class == Gift
        render :new_gift_message
      else
        render :new_transactional_message
      end
    end
  end

  def send_transactional_message
    if params[:reply_address] == current_user.email
      reply_address = "#{current_user.name} via Lacquer Love&Lend <#{params[:reply_address]}>"
    elsif params[:reply_address] == "do not provide a reply address"
      reply_address = "#{current_user.name} via Lacquer Love&Lend <noreply@lacquerloveandlend.com>"
    elsif is_an_email_address?(params[:other_reply_address])
      reply_address = params[:other_reply_address]
    end
    if !reply_address
      flash[:alert] = "Please enter a valid email address or choose another 'reply to' option from the dropdown menu."
      redirect_to :back
    else
      subject, body, to_address, transaction_id = params[:subject], params[:body], params[:to_address], params[:transaction_id]
      if !is_an_email_address?(to_address)
        flash[:alert] = "Sorry, it seems #{params[:to_name]} has not provided us with a valid email address."
        redirect_to :back
      else
        UserMailer.transactional_message(current_user.name, current_user.email, reply_address, to_address, subject, body, transaction_id).deliver_now
        flash[:success] = "Your message to #{params[:to_name]} has been sent. We sent a copy to you for your convenience."
        redirect_to user_path(current_user)
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :provider, :uid)
  end

end
