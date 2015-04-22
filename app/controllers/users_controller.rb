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
      @transactions = @user.transactions
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
      flash[:alert] = "Sign in to start inviting friends!"
      redirect_to root_path
    end
  end

  def invite_friends
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
    redirect_to user_path(@user)
  end

  def new_transactional_message
    @transaction = Transaction.find(params[:transaction_id])
    @user = current_user
    if @transaction.requester_id == current_user.id
      @other_user = User.find(@transaction.owner.id)
    else
      @other_user = User.find(@transaction.requester_id)
    end
  end

  # params:
  # {"utf8"=>"✓",
 # "authenticity_token"=>
 #  "bvoh1ic8SqGhFs6x0TZ1vgLJHwjP2AJik7N1QN/# MYD9Ni5GSWaicEwnvjqiyN4aOfNxK3yGyDp2gjjRNROwCKQ==",
 # "reply_address"=>"lacquerloveandlend@gmail.com",
 # "subject"=>"About our transaction for 12th Street Rag"# ,
 # "body"=>"Hello this is a test",
 # "commit"=>"Send",
 # "controller"=>"users",
 # "action"=>"send_transactional_message"}
  def send_transactional_message
    if params[:reply_address] == current_user.email
      reply_address = params[:reply_address]
    elsif params[:reply_address] == "do not provide a reply address"
      reply_address = "#{current_user.name} via Lacquer Love&Lend (do not reply)"
    elsif is_an_email_address?(params[:other_reply_address])
      reply_address = params[:other_reply_address]
    end
    if !reply_address
      flash[:alert] = "The reply address you entered is not a valid email address."
      redirect_to :back
    else
      subject, body, to_address = params[:subject], params[:body], params[:to_address]
      binding.pry
      #UserMailer.transactional_message(current_user.email, reply_address, to_address, subject, body).deliver_now
      flash[:success] = "Your message to #{params[:to_name]} has been sent. We sent a copy to you for your convenience."
      redirect_to user_path(current_user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :provider, :uid)
  end

end
