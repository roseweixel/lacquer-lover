require 'date'

class TransactionsController < ApplicationController
  def create
    @user = User.find(params[:transaction][:owner_id])
    @user_lacquer = UserLacquer.find(params[:transaction][:user_lacquer_id])
    owner = User.find(@user_lacquer.user_id)
    lacquer = Lacquer.find(@user_lacquer.lacquer_id)
    @transaction = Transaction.new(user_lacquer_id: params[:transaction][:user_lacquer_id], requester_id: params[:transaction][:requester_id], owner_id: params[:transaction][:owner_id], type: params[:transaction][:type], due_date: params[:transaction][:due_date])
    #transaction.state = 'pending'
    if @transaction.save
      #binding.pry
      UserMailer.loan_request_notification(@transaction.owner, @transaction.requester, @transaction.user_lacquer).deliver_now
      respond_to do |format|
        format.js { flash[:notice] = "You've successfully asked #{owner.first_name} to loan you #{lacquer.name}" }
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    original_state = @transaction.state
    @user_lacquer = UserLacquer.find(@transaction.user_lacquer_id)
    if params[:state]
      @transaction.update(state: params[:state])
    end
    if params[:loan] && params[:loan][:due_date]
      @transaction.update(due_date: params[:loan][:due_date])
    end
    if params[:transaction] && params[:transaction][:due_date]
      if @transaction.update(due_date: params[:transaction][:due_date])
        UserMailer.loan_due_date_notification(@transaction).deliver_now
        flash[:notice] = "We've notified #{@transaction.requester.name} that #{@transaction.lacquer.name} is due back by #{@transaction.due_date.strftime("%m/%d/%Y")}!"
      elsif @transaction.errors.any?
        flash[:error] = @transaction.errors.full_messages.to_sentence.gsub("Transaction ", "")
      end
    end
    if params[:date_became_active]
      @transaction.update(date_became_active: params[:date_became_active])
    end
    if @transaction.state == 'accepted'
      @user_lacquer.on_loan = true
      @user_lacquer.save
      if original_state == 'pending'
        UserMailer.loan_request_accepted_notification(@transaction).deliver_now
      end
    elsif @transaction.state == 'completed'
      @user_lacquer.on_loan = false
      @user_lacquer.save
      @transaction.date_ended = Date.today
    end
    redirect_to(:back)
  end

  def destroy
    if params[:loan]
      @user_lacquer = UserLacquer.find(params[:loan][:user_lacquer_id])
    elsif params[:transaction]
      @user_lacquer = UserLacquer.find(params[:transaction][:user_lacquer_id])
    end
    @user = User.find(params[:transaction][:owner_id])
    @transaction = Transaction.find(params[:id])
    if @transaction.state == 'pending' && @transaction.requester == current_user
      @transaction.destroy
    else
      flash[:notice] = "The transaction could not be deleted at this time."
    end
    respond_to do |format|
      format.js { }
    end
    #redirect_to(:back)
  end

  # private
  #   def transaction_params
  #     params.require(:transaction).permit(:type, :user_lacquer_id, :requester_id)
  #   end
end
