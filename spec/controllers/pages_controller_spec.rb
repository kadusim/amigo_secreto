require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "GET #home" do

    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "User redirect to home when have campaigns" do
      @campaign = create(:campaign, user: @current_user)
      get :home
      expect(response).to redirect_to("/campaigns")
    end

  end

end
