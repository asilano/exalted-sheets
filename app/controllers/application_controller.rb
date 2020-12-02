class ApplicationController < ActionController::Base
  before_action :get_discord_name

  private

  def get_discord_name
    if current_user&.discord_uid.present?
      current_user.discord_name = DiscordApiService.username(current_user.discord_uid)
    end
  end
end
