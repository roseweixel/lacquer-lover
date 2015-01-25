require 'rails_helper'
include IntegrationSpecHelper


RSpec.describe UsersController, :type => :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe 'GET /users/:id.json' do 
    before do 
      login_with_oauth
      @user = User.first
      @color1 = create(:color, name: "red")
      @color2 = create(:color, name: "berry")
      @finish1 = create(:finish, description: "creme")
      @finish2 = create(:finish, description: "holographic")
      @finish3 = create(:finish, description: "shimmer")
      @brand1 = create(:brand, name: "OPI")
      @lacquer1 = create(:lacquer, brand_id: 1, name: "The Thrill of Brazil", default_picture: 'app/assets/images/file-not-found.png')
      @lucys_lacquer1 = create(:user_lacquer, user_id: @user.id, lacquer_id: 1)
      @lucys_lacquer_color1 = create(:user_lacquer_color, user_lacquer_id: @lucys_lacquer1.id, color_id: @color1.id)
      @lucys_lacquer_finish1 = create(:user_lacquer_finish, user_lacquer_id: @lucys_lacquer1.id, finish_id: @finish1.id)
      @brand2 = create(:brand, name: "Zoya")
      @lacquer2 = create(:lacquer, brand_id: 2, name: "Blaze", default_picture: 'app/assets/images/file-not-found.png')
      @lucys_lacquer2 = create(:user_lacquer, user_id: @user.id, lacquer_id: 2, loanable: true, on_loan: true)
      @lucys_lacquer_color2 = create(:user_lacquer_color, user_lacquer_id: @lucys_lacquer2.id, color_id: @color1.id)
      @lucys_lacquer_color3 = create(:user_lacquer_color, user_lacquer_id: @lucys_lacquer2.id, color_id: @color2.id)
      @lucys_lacquer_finish2 = create(:user_lacquer_finish, user_lacquer_id: @lucys_lacquer2.id, finish_id: @finish2.id)
      @lucys_lacquer_finish3 = create(:user_lacquer_finish, user_lacquer_id: @lucys_lacquer2.id, finish_id: @finish3.id)
      get :show, format: :json, id: @user.id
      # puts JSON.pretty_generate(json)
    end

    it 'returns one user' do 
      expect(json["id"]).to eq(@user.id)
    end

    it 'returns their lacquers as a json attribute' do 
      expect(json["lacquers"]).to_not be_empty
    end

    it "returns each lacquer's name" do
      expect(json["lacquers"][0]["name"]).to eq(@lacquer1.name)
    end 

    it "returns each lacquer's brand name" do
      expect(json["lacquers"][0]["brand"]).to eq(@lacquer1.brand.name)
    end 

    it "returns each lacquer's colors in an array" do
      expect(json["lacquers"][1]["colors"]).to eq(@lucys_lacquer2.colors.pluck(:name))
    end

    it "returns each lacquer's finishes in an array" do
      expect(json["lacquers"][1]["finishes"]).to eq(@lucys_lacquer2.finishes.pluck(:description))
    end

    it 'returns their lacquer count as a json attribute' do
      expect(json["lacquer_count"]).to eq(User.first.lacquers.count)
    end 

  end

end
