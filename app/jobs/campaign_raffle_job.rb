class CampaignRaffleJob < ApplicationJob
  queue_as :emails

  def perform(campaign)

    results = RaffleService.new(campaign).call

    if results.present?
      campaign.members.each {|m| m.set_pixel}
      results.each do |r|
        CampaignMailer.raffle(campaign, r.first, r.last).deliver_now
      end
      campaign.update(status: :finished)
    else
      CampaignMailer.raffle_error(campaign).deliver_now
    end

  end

end
