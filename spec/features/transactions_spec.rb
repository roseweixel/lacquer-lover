# describe "making a lacquer loanable" do
#   before(:each) do
#     @brand = create(:brand, name: "OPI")
#     @lacquer1 = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")

#     # Log in as Lucy Lacquers
#     login_with_oauth

#     @user1 = User.first
#     @user2 = create(:user, name: "Nancy Nails")

#     @nancys_lacquer = create(:user_lacquer, user_id: 2, lacquer_id: 1)
#     @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1)
#   end

#   # it "allows a user to make their lacquer loanable" do
#     # visit('/users/1')
#     #save_and_open_page
#     # expect(@lucys_lacquer.loanable).to eq(false)
#     # click_button('make loanable')
#     #binding.pry
#     # expect{
#     #   click_button('make loanable')
#     # }.to change{@lucys_lacquer.loanable}.from(false).to(true)
#   # end

# end