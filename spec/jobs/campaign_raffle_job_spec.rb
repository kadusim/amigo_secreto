require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do
  include ActiveJob::TestHelper

  let(:campaign) { create(:campaign) }
  let(:member) { create(:member, campaign: @campaign) }
  let(:friend) { create(:member, campaign: @campaign) }
  let(:mail) { CampaignMailer.raffle(@campaign, @member, @friend) }

  # OR
  # before do
  #   @campaign = create(:campaign)
  #   @member   = create(:member, campaign: @campaign)
  #   @friend   = create(:member, campaign: @campaign)
  #   @mail = CampaignMailer.raffle(@campaign, @member, @friend)
  # end

  describe "#email job" do

    it "when send email to members" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        CampaignRaffleJob.perform_later('raffle')
      }.to have_enqueued_job
    end

  end

end
