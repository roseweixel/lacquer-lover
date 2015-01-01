require 'rails_helper'
require 'support/integration_spec_helper'
include IntegrationSpecHelper

context 'when visiting the home page' do
  before(:each) do
    visit(root_path)
  end

  it 'responds with 200' do
    #save_and_open_page
    expect(page.status_code).to be(200)
  end

  context 'when signed in' do
    before(:each) do
      login_with_oauth
    end

    it "shows a link to the current user's profile page" do
      expect(page).to have_content('Welcome, Lucy! See your profile.')
    end

    it "has a sign out link that signs the user out" do
      expect(page).to have_content('Sign Out')
      click_link('Sign Out')
      expect(page).to have_content('Sign in with Facebook')
    end
  end
end