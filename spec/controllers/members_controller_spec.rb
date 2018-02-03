require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
    @campaign = create(:campaign, user: @current_user)

    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "#POST #create" do

    context "when parameters ok" do

      before(:each) do
        @member = build(:member, campaign: @campaign)
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "create member with right attributes" do
        expect(Member.last.name).to eql(@member.name)
        expect(Member.last.email).to eql(@member.email)
      end

      it "member associate the right campaign" do
        expect(Member.last.campaign).to eql(@member.campaign)
        expect(Member.last.campaign.id).to eql(@member.campaign.id)
      end

    end

    context "when parameters nok" do

      before(:each) do
        @member = build(:member, campaign: @campaign)
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
      end

      it "email has already been associated" do
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end

    context "when User not is Owner of campaign" do

      before(:each) do
        @current_user_other = FactoryBot.create(:user)
        sign_in @current_user_other
      end

      it "user is not owner of campaign" do
        @member = build(:member, campaign: @campaign)
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
        expect(response).to have_http_status(:forbidden)
      end

    end

  end

end
