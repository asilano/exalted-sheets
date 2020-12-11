module DiscordBot
  class Users < Grape::API
    helpers do
      def unuse_chars
        @user.characters.where(discord_server_uid: params[:server_uid]).find_each { |char| char.discord_server_uid = nil; char.save! }
      end
    end

    get :characters do
      { characters: @user.characters.select(:id, :name, :spark, :caste, :concept) }
    end

    post :use_character do
      unuse_chars
      char = @user.characters.where(Character.arel_table[:name].lower.matches(params[:name].downcase)).first
      error!('No character with that name', 404) unless char

      char.discord_server_uid = params[:server_uid]
      char.save!
      char
    end

    delete :unuse_character do
      unuse_chars
      { unused: 'ok' }
    end
  end
end
