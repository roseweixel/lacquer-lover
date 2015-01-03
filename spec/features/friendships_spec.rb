context "when looking for friends" do

  describe "trying to view the users index when not signed in" do

    it "redirects to root" do
      visit '/users'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please sign in to continue!')
    end
  end

  describe "viewing the users index when signed in" do
    before(:each) do
      @user1 = create(:user, name: "Polly Polish")
      @user2 = create(:user, name: "Nancy Nails")

      # log in as Lucy Lacquers
      login_with_oauth
      visit '/users'
    end

    it "lists all users with links to profiles" do
      expect(page).to have_link('Polly Polish', :href=>"/users/#{@user1.id}")
      expect(page).to have_link('Nancy Nails', :href=>"/users/#{@user2.id}")
      expect(page).to_not have_content('Lucy Lacquers')
    end

  end

end

context "when adding a friend" do

  describe "trying to view another user's profile when not signed in" do

    before do
      @user1 = create(:user, name: "Polly Polish")
      visit "/users/#{@user1.id}"
    end

    it "redirects to root" do
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please sign in to continue!')
    end
  end

  describe "viewing another (non-friend) user's profile when signed in" do
    before(:each) do
      @user1 = create(:user, name: "Polly Polish")
      @user2 = create(:user, name: "Nancy Nails")

      # log in as Lucy Lacquers
      login_with_oauth
      visit '/users'
      click_link('Polly Polish')
    end

    it "redirects to the correct user's profile page" do
      expect(page).to have_content('Polly Polish')
    end

    it "has a button to add a friend" do
      expect(page).to have_link('Add Friend', :href=>"/friendships/new?friend_id=#{@user1.id}")
    end
  end

  describe "requesting a friendship" do
    before(:each) do
      @user1 = create(:user, name: "Polly Polish")
      @user2 = create(:user, name: "Nancy Nails")

      # log in as Lucy Lacquers
      login_with_oauth
      visit '/users'
      click_link('Polly Polish')
    end

    it "creates a pending friendship" do
      click_link("Add Friend")
      expect(page).to have_content("Do you really want to friend #{@user1.first_name}?")
      expect(page).to have_button('Yes, Add Friend')
      expect(page).to have_link('Cancel')

      click_button('Yes, Add Friend')
      expect(page).to have_content("Your friendship with #{@user1.name} is pending.")
      expect(Friendship.last.state).to eq('pending')
      expect(User.find(Friendship.last.user_id).name).to eq("Lucy Lacquers")
      expect(User.find(Friendship.last.friend_id).name).to eq("#{@user1.name}")
      click_link('Welcome, Lucy! See your profile.')
      expect(page).to have_content("Your Pending Friend Requests")
      expect(page).to have_link("#{@user1.name}")
    end

    it "does not allow duplicate friendships" do
      expect{
      click_link("Add Friend")
      click_button('Yes, Add Friend')
      }.to change{Friendship.count}.from(0).to(1)
      
      expect{
        Friendship.create(user_id: 3, friend_id: 1)
        Friendship.create(user_id: 1, friend_id: 3)
      }.to_not change{Friendship.count}
    end
  end

  describe "accepting or rejecting a friendship" do
    before(:each) do
      @user1 = create(:user, name: "Polly Polish")
      @user2 = create(:user, name: "Nancy Nails")

      # log in as Lucy Lacquers
      login_with_oauth

      # create a pending friendship where Lucy is the friend (requested) and Polly is the user (requester)
      @friendship = create(:friendship, user_id: 1, friend_id: 3, state: 'pending')

      click_link('Welcome, Lucy! See your profile.')
    end

    it "allows the requested friend to accept or reject the friendship request" do
      expect(page).to have_link('Accept', :href=>"/friendships/#{@friendship.id}?state=accepted")
      expect(page).to have_link('Reject', :href=>"/friendships/#{@friendship.id}?state=rejected")
    end

    it "updates the friendship state to 'accepted' when the 'Accept' button is clicked" do
      click_link('Accept')
      expect(Friendship.last.state).to eq('accepted')
      expect(page).to have_content("Friends")
      expect(page).to have_link("#{@friendship.user.name}")
    end

    it "updates the friendship state to 'rejected' when the 'Reject' button is clicked" do
      click_link('Reject')
      expect(Friendship.last.state).to eq('rejected')
      expect(page).to_not have_link("#{@friendship.user.name}")
    end
  end

  describe "concluding a friendship" do

    before(:each) do
      @user1 = create(:user, name: "Polly Polish")
      @user2 = create(:user, name: "Nancy Nails")

      # log in as Lucy Lacquers
      login_with_oauth

      # create a pending friendship where Lucy is the friend (requested) and Polly is the user (requester)
      @friendship = create(:friendship, user_id: 3, friend_id: 2, state: 'rejected')

      click_link('Welcome, Lucy! See your profile.')
    end

    it "allows a user to conclude a friendship request that was rejected" do
      expect(page).to have_link("conclude this request", :href=>"/friendships/#{@friendship.id}?state=concluded")
    end 

    it "updates the friendship state to 'concluded' when the 'conclude this request' link is clicked" do
      click_link('conclude this request')
      expect(Friendship.last.state).to eq('concluded')
      expect(page).to_not have_link("#{@friendship.friend.name}")
    end
  end

end
