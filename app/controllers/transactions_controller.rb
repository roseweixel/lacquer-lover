require 'date'

class TransactionsController < ApplicationController
  def create
    @user = User.find(params[:transaction][:owner_id])
    @user_lacquer = UserLacquer.find(params[:transaction][:user_lacquer_id])
    owner = User.find(@user_lacquer.user_id)
    lacquer = Lacquer.find(@user_lacquer.lacquer_id)
    @transaction = Transaction.new(user_lacquer_id: params[:transaction][:user_lacquer_id], requester_id: params[:transaction][:requester_id], owner_id: params[:transaction][:owner_id], due_date: params[:transaction][:due_date])
    if @transaction.save
      UserMailer.loan_request_notification(@transaction.owner, @transaction.requester, @transaction.user_lacquer).deliver_now if @transaction.owner.email
      respond_to do |format|
        format.js { flash[:notice] = "You've successfully asked #{owner.first_name} to loan you #{lacquer.name}" }
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    original_state = @transaction.state
    if params[:state]
      @transaction.update(state: params[:state])
    end
    if params[:loan] && params[:loan][:due_date]
      @transaction.update(due_date: params[:loan][:due_date])
    end
    if params[:transaction] && params[:transaction][:due_date]
      if @transaction.update(due_date: params[:transaction][:due_date])
        if @transaction.requester.email
          UserMailer.loan_due_date_notification(@transaction).deliver_now 
          flash[:notice] = "We've notified #{@transaction.requester.name} that #{@transaction.lacquer.name} is due back by #{@transaction.due_date.strftime("%m/%d/%Y")}!"
        else
          flash[:notice] = "A notification has been posted on #{@transaction.requester.name}'s profile that #{@transaction.lacquer.name} is due back by #{@transaction.due_date.strftime("%m/%d/%Y")}!"
        end
      elsif @transaction.errors.any?
        flash[:error] = @transaction.errors.full_messages.to_sentence.gsub("Transaction ", "")
      end
    end
    if params[:date_became_active]
      @transaction.update(date_became_active: params[:date_became_active])
    end
    if @transaction.state == 'accepted'
      if original_state == 'pending' && @transaction.requester.email
        UserMailer.loan_request_accepted_notification(@transaction).deliver_now
      end
    elsif @transaction.state == 'returned_unconfirmed' && @transaction.owner.email
      UserMailer.lacquer_returned_notification(@transaction).deliver_now
    elsif @transaction.state == 'completed'
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
    @user = User.find(params[:transaction][:owner_id]) if params[:transaction]
    @transaction = Transaction.find(params[:id])
    if @transaction.destroy
      flash[:notice] = "The transaction was successfully deleted."
    else
      flash[:notice] = "The transaction could not be deleted at this time."
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js { }
    end
  end

  # private
  #   def transaction_params
  #     params.require(:transaction).permit(:type, :user_lacquer_id, :requester_id)
  #   end
end
