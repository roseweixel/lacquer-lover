require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "#create" do
 
    it "should successfully create a user" do
      expect {
        post :create, provider: :facebook
      }.to change{ User.count }.by(1)
    end

    it "should successfully create a session" do
      expect(session[:user_id]).to be_nil
      post :create, provider: :facebook
      expect(session[:user_id]).to_not be_nil
    end
 
    it "should redirect the user to the root url" do
      post :create, provider: :facebook
      expect(response).to redirect_to root_url
    end

  end

  describe "#destroy" do
    before do
      post :create, provider: :facebook
    end
 
    it "should clear the session" do
      expect(session[:user_id]).to_not be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
 
    it "should redirect to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end

end

