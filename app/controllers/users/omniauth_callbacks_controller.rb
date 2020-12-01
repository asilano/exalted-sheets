module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all(kind)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      else
        session["devise.#{kind}_data"] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        render 'devise/registrations/new'
      end
    end

    def failure
      redirect_to root_path
    end

    def google_oauth2
      all 'Google'
    end

    def discord
      all 'Discord'
    end
  end
end
