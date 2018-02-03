require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "#POST #create" do

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:user)
      sign_in @current_user

      @campaign = create(:campaign, user: @current_user)
      @member = build(:member, campaign: @campaign)
      post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}

      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "Create member with right attributes" do
      expect(Member.last.name).to eql(@member.name)
      expect(Member.last.email).to eql(@member.email)
    end

    it "Member associate the right campaign" do
      expect(Member.last.campaign).to eql(@member.campaign)
      expect(Member.last.campaign.id).to eql(@member.campaign.id)
    end

    it "Email has already been associated" do
      post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    xit "User is not Owner of Campaign" do
      expect(response).to have_http_status(:forbidden)
    end

  end

end
