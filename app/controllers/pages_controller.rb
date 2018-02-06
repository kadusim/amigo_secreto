class PagesController < ApplicationController
  def home
    if current_user
      if current_user.campaigns.count > 0
        redirect_to campaigns_path
      end
    end
    # user_have_campaigns = current_user and current_user.campaigns.count > 0
    # if user_have_campaigns
    #     redirect_to campaigns_path
    # end
  end
end
