require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
    @campaign = create(:campaign, user: @current_user)

  end

  describe "#POST #create" do

    context "when parameters ok" do

      before(:each) do
        @member = build(:member, campaign: @campaign)
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
        request.env["HTTP_ACCEPT"] = 'application/json'
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
        request.env["HTTP_ACCEPT"] = 'application/json'
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
        request.env["HTTP_ACCEPT"] = 'application/json'
      end

      it "user is not owner of campaign" do
        @member = build(:member, campaign: @campaign)
        post :create, params: {member: {name: @member.name, email: @member.email, campaign_id: @member.campaign_id}}
        expect(response).to have_http_status(:forbidden)
      end

    end

  end

  describe "#DELETE destroy" do

    context "when parameters ok" do

      before(:each) do
        @member = create(:member, campaign: @campaign)
        delete :destroy, params: {id: @member.id}
        request.env["HTTP_ACCEPT"] = 'application/json'
      end

      it 'return http sucess' do
        expect(response).to have_http_status(:success)
      end

      it "member removed" do
        found = @campaign.members.detect {|m| m.id == @member.id}
        expect(found).to be_nil
      end

    end

    context "when parameters nok" do

      before(:each) do
        request.env["HTTP_ACCEPT"] = 'application/json'
      end

      it "member not found" do
        member = create(:member, campaign: @campaign)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:success)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:not_found)
      end

    end

    context "when User not is Owner of campaign" do

      before(:each) do
        @member = create(:member, campaign: @campaign)
        @current_user_other = FactoryBot.create(:user)
        sign_in @current_user_other
        request.env["HTTP_ACCEPT"] = 'application/json'
      end

      it "user is not owner of campaign" do
        delete :destroy, params: {id: @member.id}
        expect(response).to have_http_status(:forbidden)
      end

    end

  end

  describe "#UPDATE" do

    before(:each) do
      @new_member_attributes = attributes_for(:member)
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "when parameters ok" do

      before(:each) do
        member = create(:member, campaign: @campaign)
        put :update, params: {id: member.id, member: @new_member_attributes}
      end

      it 'return http sucess' do
        expect(response).to have_http_status(:success)
      end

      it "Member have the new attributes" do
        expect(Member.last.name).to eq(@new_member_attributes[:name])
        expect(Member.last.email).to eq(@new_member_attributes[:email])
      end

    end

  end

end
