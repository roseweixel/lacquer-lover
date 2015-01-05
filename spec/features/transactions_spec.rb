describe "lacquer loans" do
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
    
  end

  it "allows a user to make their lacquer loanable or unloanable" do
    visit('/users/1')
    
    expect(page).to have_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=true")
    click_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=true")
    expect(page).to have_link('✔', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=false")
    expect(UserLacquer.last.loanable).to eq(true)

    click_link('✔', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=false")
    expect(page).to have_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=true")
    expect(UserLacquer.last.loanable).to eq(false)
  end

  it "allows a user to mark their lacquer on loan or not on loan" do
    visit('/users/1')
    click_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bloanable%5D=true")
    
    expect(UserLacquer.last.loanable).to eq(true)
    expect(UserLacquer.last.on_loan).to eq(false)
    expect(page).to have_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bon_loan%5D=true")

    click_link('✕', :href =>"/user_lacquers/#{@lucys_lacquer.id}?user_lacquer%5Bon_loan%5D=true")
    expect(UserLacquer.last.on_loan).to eq(true)

    # does not allow transactions when on loan
    expect{
      Transaction.create(user_lacquer_id: 1)
    }.to_not change{Transaction.count}
  end

  it "allows friends to request loans from friends only when lacquer is loanable and not already on loan" do

    # does not allow transactions when not friends
    expect{
      Transaction.create(user_lacquer_id: 1)
    }.to_not change{Transaction.count}

    @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
    
    visit('/users/2')

    expect(page).to_not have_content('Can I borrow this?')

    expect{
      Transaction.create(user_lacquer_id: 1)
    }.to_not change{Transaction.count}

    @nancys_lacquer.update(loanable: true)

    visit('/users/2')

    expect(page).to have_button('Can I borrow this?')

    expect{
      click_button('Can I borrow this?')
    }.to change{Transaction.count}.from(0).to(1)

    expect(page).to have_content("You've successfully asked #{@user2.first_name} to loan you #{@lacquer.name}")
    expect(page).to_not have_content('Can I borrow this?')
    expect(page).to have_button('delete pending request')

    visit('/users/1')

    expect(page).to have_content('Pending Loan Requests')
    expect(page).to have_content("You've asked #{@user2.name} to loan you #{@lacquer.name}")

    visit('/users/2')

    expect{
      click_button('delete pending request')
    }.to change{Transaction.count}.from(1).to(0)

    expect(page).to have_button('Can I borrow this?')
  end

  describe "accepting or rejecting transaction requests" do
    before(:each) do
      @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      @lucys_lacquer.update(loanable: true)
      @transaction = Transaction.create(requester_id: 2, user_lacquer_id: 2)
    end

    it "allows the owner of the requested lacquer to accept the request" do 
      # @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      # @lucys_lacquer.update(loanable: true)
      # @transaction = Transaction.create(requester_id: 2, user_lacquer_id: 2)

      expect(Transaction.last.state).to eq('pending')
      
      visit('/users/1')

      expect(page).to have_content('Transactions Awaiting Your Approval')
      expect(page).to have_content("#{@transaction.requester.name} has asked to borrow #{@lucys_lacquer.lacquer.name}.")

      expect(page).to have_link('Accept Request')
      expect(page).to have_link('Reject Request')

      click_link('Accept Request')
      expect(Transaction.last.state).to eq('accepted')

    end

    it "allows the owner of the requested lacquer to 'activate' the loan when they give the lacquer to the requester" do
      # @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      # @lucys_lacquer.update(loanable: true)
      # @transaction = Transaction.create(requester_id: 2, user_lacquer_id: 2)
      
      visit('/users/1')
      #binding.pry
      expect(Transaction.last.state).to eq('pending')

      click_link('Accept Request')
      #binding.pry
      expect(page).to have_link("I gave The Thrill of Brazil to Nancy Nails")

      click_link("I gave The Thrill of Brazil to Nancy Nails")

      expect(Transaction.last.state).to eq('active')
    end

    it "allows the owner of the requested lacquer to reject the request" do
      # @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      # @lucys_lacquer.update(loanable: true)
      # @transaction = Transaction.create(requester_id: 2, user_lacquer_id: 2) 
      
      expect(Transaction.last.state).to eq('pending')
      
      visit('/users/1')

      expect(page).to have_content('Transactions Awaiting Your Approval')
      expect(page).to have_content("#{@transaction.requester.name} has asked to borrow #{@lucys_lacquer.lacquer.name}.")

      expect(page).to have_link('Accept Request')
      expect(page).to have_link('Reject Request')

      click_link('Reject Request')
      expect(Transaction.last.state).to eq('rejected')
      expect(@lucys_lacquer.on_loan).to eq(false)
    end

    it "allows the requester of a rejected transaction to conclude a request" do
      # @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      @nancys_lacquer.update(loanable: true)
      @transaction = Transaction.create(requester_id: 1, user_lacquer_id: 1, state: 'rejected') 
      
      visit('/users/1')

      #save_and_open_page
      expect(page).to have_content("It seems Nancy Nails isn't able to loan you The Thrill of Brazil at this time.")
      expect(page).to have_link("conclude this request")

      click_link("conclude this request")

      expect(Transaction.last.state).to eq("completed")

    end

    it "does not allow duplicate loan requests" do
      # @friendship = Friendship.create(user_id: 1, friend_id: 2, state: 'accepted')
      @nancys_lacquer.update(loanable: true)
      @valid_transaction = Transaction.create(requester_id: 1, user_lacquer_id: 1, state: 'rejected') 
      
      @invalid_transaction = Transaction.create(requester_id: 1, user_lacquer_id: 1, state: 'pending')
      expect(@invalid_transaction.errors.messages[:transaction]).to include("This request already exists!")
    end

  end

end