require 'rails_helper'

RSpec.describe UserLacquersController, :type => :controller do

  describe 'DELETE #destroy' do
    before(:each) do
      @brand = create(:brand, name: "OPI")
      @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")

      # Log in as Lucy Lacquers
      login_with_oauth
      @user1 = User.first
      @user2 = create(:user, name: "Nancy Nails")
    end

    it "does not allow a user to destroy a user_lacquer that is not theirs" do
      @nancys_lacquer = create(:user_lacquer, user_id: 2, lacquer_id: 1)
      @request.env['HTTP_REFERER'] = '/user_lacquers/destroy'
      #binding.pry
      session[:user_id] = @user1.id

      #binding.pry
      expect(UserLacquer.count).to eq(1)
      delete :destroy, :id => @nancys_lacquer
      expect(UserLacquer.count).to eq(1)
      #binding.pry
      expect(flash[:notice]).to eq("You can't delete another user's lacquer!")
    end

    it "does not allow a user to destroy a user_lacquer that is on loan" do
      @lucys_lacquer = create(:user_lacquer, user_id: 1, lacquer_id: 1, loanable: true, on_loan: true)
      @request.env['HTTP_REFERER'] = '/user_lacquers/destroy'
      session[:user_id] = @user1.id
      expect(UserLacquer.count).to eq(1)
      delete :destroy, :id => @lucys_lacquer
      expect(UserLacquer.count).to eq(1)
      expect(flash[:notice]).to eq("There was an error deleting this lacquer!")

    end
  end

  describe '#update' do
    before(:each) do
      @brand = create(:brand, name: "OPI")
      @lacquer = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil")

      # Log in as Lucy Lacquers
      login_with_oauth
      @user1 = User.first
      @user2 = create(:user, name: "Nancy Nails")
    end
    it "does not allow a user to update a user_lacquer that is not theirs" do
      @nancys_lacquer = create(:user_lacquer, user_id: 2, lacquer_id: 1)
      @request.env['HTTP_REFERER'] = '/user_lacquers/update'
      expect{ patch :update, id: @nancys_lacquer, loanable: true }.not_to change{@nancys_lacquer}
    end
  end


end
