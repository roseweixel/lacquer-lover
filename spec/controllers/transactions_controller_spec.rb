require 'rails_helper'

RSpec.describe TransactionsController, :type => :controller do
  before(:each) do
    @brand = create(:brand, name: "OPI")
    @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")

    # Log in as Lucy Lacquers
    login_with_oauth

    @user1 = User.first
    @user2 = create(:user, name: "Nancy Nails")

    # creates relationships and takes snapshots in memory (will not get automatically updated when the database is updated)
    @nancys_lacquer = create(:user_lacquer, user_id: 2, lacquer_id: 1)
    @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1)

    @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
    @nancys_lacquer.update(loanable: true)
    @transaction = Transaction.create(requester_id: 1, user_lacquer_id: 1) 
  end

  describe '#destroy' do
    it "does not destroy an active transaction" do
      @request.env['HTTP_REFERER'] = '/transactions/destroy'
      @transaction.update(state: 'active')
      expect{ delete :destroy, id: @transaction }.not_to change{Transaction.count}
    end

  end

end
