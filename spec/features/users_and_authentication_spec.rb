require 'rails_helper'
require 'support/integration_spec_helper'
include IntegrationSpecHelper

context 'when visiting the home page' do
  before(:each) do
    @brand1 = create(:brand, name: "OPI")
    @brand2 = create(:brand, name: "Essie")
    @brand3 = create(:brand, name: "Butter London")
    @brand4 = create(:brand, name: "Deborah Lippmann")
    @other_user = create(:user, name: "Nancy Nails")
    visit(root_path)
  end

  it 'responds with 200' do
    expect(page.status_code).to be(200)
  end

  context 'when signed in' do
    before(:each) do
      login_with_oauth
    end

    it "shows a link to the signed in user's profile page" do
      expect(page).to have_content('Welcome, Lucy! See your profile.')
    end

    context 'when visiting a user profile' do
      it "redirects to the signed in user's profile when profile link is clicked" do
        click_link('Welcome, Lucy! See your profile.')
        expect(page).to have_content('Your Profile')
        expect(page).to have_content('Your Lacquers')
        expect(page).to have_content('Add A Lacquer')
      end

      it "shows the appropriate profile page when navigating to another user's profile" do
        
        visit('users/1')
        
        expect(page).to have_content("Nancy's Profile")
        expect(page).to_not have_content("Add A Lacquer")
        expect(page).to_not have_content("Remove From Your Collection")
      end
    end

    it "has a sign out link that signs the user out" do
      expect(page).to have_content('Sign Out')
      click_link('Sign Out')
      expect(page).to have_content('Sign in with Facebook')
    end
  end
end