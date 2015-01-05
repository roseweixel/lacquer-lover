require 'rails_helper'
include IntegrationSpecHelper

describe "adding a due date to a lacquer loan" do
  before do
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
    @lucys_lacquer.update(loanable: true)
    
  end

  it "allows the owner of the transaction to set or update a due date", js: true do
    @transaction = Transaction.create(requester_id: 2, user_lacquer_id: 2)
    visit('/users/1')
    #binding.pry
    expect(Transaction.last.state).to eq('pending')

    click_link('Accept Request')
    #binding.pry
    expect(Transaction.last.state).to eq('accepted')
    expect(page).to have_content('Add or Update Due Date')

    # # set a due date
    page.find('#loan_due_date').set("06-01-2015")
    click_button('Update Loan')

    expect(Transaction.last.due_date).to eq("2015-01-06")

    # update a due date
    # page.find('#transaction_due_date').set("07-01-2015")
    # click_button('Update Transaction')

    # expect(Transaction.last.due_date).to eq("2015-01-07")
  end
end