module DiscordBot
  class API < Grape::API
    AUTH_TOKEN = ENV['EXALTED_API_TOKEN']
    version 'v1'
    format :json
    prefix :api

    helpers do
      def authenticate
        headers['Authorization'] == AUTH_TOKEN
      end
    end

    before do
      error!('401 Unauthorized', 401) unless authenticate
    end

    namespace :users do
      route_param :id, type: Integer do
        before do
          @user = User.find(params[:id])
        end
        mount Users
      end

      namespace :discord do
        route_param :id, type: Integer do
          before do
            @user = User.find_by(discord_uid: params[:id])
          end
          mount Users
        end
      end
    end
  end
end
