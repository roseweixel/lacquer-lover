require 'rails_helper'
include IntegrationSpecHelper

RSpec.describe LacquersController, :type => :controller do
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

  describe '#create' do
    it "will not create a lacquer without valid inputs" do
      @request.env['HTTP_REFERER'] = '/lacquers/create'
      expect{ post :create, :lacquer => {:name => "", :brand_id => 1} }.not_to change{Lacquer.count}
    end
  end

  describe '#edit' do
    it "will not allow a user to edit a lacquer that is not in their collection" do
      session[:user_id] = @user1.id
      @request.env['HTTP_REFERER'] = '/lacquers/edit'
      #binding.pry
      get :edit, id: @lacquer, user_lacquer_id: @nancys_lacquer
      assert_response :redirect
      expect(flash[:alert]).to eq("You cannot edit a lacquer that is not in your collection!")
    end
  end

end
