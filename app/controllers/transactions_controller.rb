class TransactionsController < ApplicationController
  def create
    user_lacquer = UserLacquer.find(params[:transaction][:user_lacquer_id])
    owner = User.find(user_lacquer.user_id)
    lacquer = Lacquer.find(user_lacquer.lacquer_id)
    transaction = Transaction.new(transaction_params)
    transaction.state = 'pending'
    if transaction.save
      flash[:notice] = "You've successfully asked #{owner.first_name} to loan you #{lacquer.name}"
      redirect_to(:back)
    else
      flash[:notice] = "Loan request unsuccessful."
      redirect_to(:back)
    end
  end

  def destroy
    @user = current_user
    @transaction = Transaction.find(params[:id])
    if @transaction.state == 'pending' && @transaction.requester == current_user
      @transaction.destroy
    else
      flash[:notice] = "Requesters can only destroy pending transactions"
    end
    redirect_to(:back)
  end

  private
    def transaction_params
      params.require(:transaction).permit(:type, :user_lacquer_id, :requester_id)
    end
end
