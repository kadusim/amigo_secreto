require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "#POST #create" do
    before(:each) do
      @member = create(:member)
    end

    it "Create member with right attributes" do
      expect(Member.last.name).to eql(@member.name)
      expect(Member.last.email).to eql(@member.email)
    end

    it "Member associate the right campaign" do
      expect(Member.last.campaign).to eql(@member.campaign)
      expect(Member.last.campaign.id).to eql(@member.campaign.id)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "Member has already been associated" do
      # @member_dup = build(:member, name: @member.name, email: @member.email, campaign: @member.campaign)
      # expect(response).to have_http_status(:success)
      #
      # @member_test = attributes_for(:member, name: @member.name, email: @member.email, campaign: @member.campaign)
      # post :create, params: {member: @member_test}
      # expect(response).to have_http_status(:success)

      member_params = attributes_for(:member, name: @member.name, email: @member.email, campaign: @member.campaign)
      Member.new(member_params)
      expect(response).to have_http_status(:success)
    end

  end

end
