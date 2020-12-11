Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations:      'users/registrations'
  }
  devise_scope :user do
    put '/unlink', to: 'users/registrations#unlink_discord', as: :unlink_discord_from_user
  end
  resources :characters, except: :show
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/discord/:discordian', to: redirect { |params, req|
    existing = Character.find_by(discord_user: params[:discordian])
    if existing
      Rails.application.routes.url_helpers.edit_character_path(existing)
    else
      Rails.application.routes.url_helpers.new_character_path(discord_user: params[:discordian])
    end
  }

  mount DiscordBot::API => '/'

  root to: 'characters#index'
end
