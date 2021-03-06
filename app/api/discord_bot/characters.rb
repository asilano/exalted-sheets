module DiscordBot
  class Characters < Grape::API
    RESOURCES = {
      'wp'      => :remaining_wp,
      'pers'    => :remaining_personal_ess,
      'periph'  => :remaining_periph_ess,
      'anima'   => :anima_level,
      'xp'      => :unspent_xp,
      'sparkxp' => :unspent_spark_xp,
      'limit'   => :limit_break
    }
    helpers do
      def adjust(resource, amount)
        method = RESOURCES[resource]
        error!("'#{resource}' is not recognised.", 400) unless method

        current = @character.send(method)
        left = current + amount
        error!("Can't pay #{amount}; only have #{current}", 400) if left.negative?

        @character.send("#{method}=", left)
        if @character.save
          {
            'char_name' => @character.name,
            'new_value' => left
          }
        else
          error!("Couldn't update character - #{@character.errors.full_messages.join(', ')}", 400)
        end
      end
    end

    get do
      @character || {}
    end

    get :pools do
      parsed = []
      response = params[:pools].to_h do |pool|
        [
          pool,
          case pool.downcase
          when 'permwp'
            parsed << 'Willpower'
            @character.permanent_wp
          when 'tempwp'
            parsed << 'Remaining Willpower'
            @character.remaining_wp
          when 'ess'
            parsed << 'Essence'
            @character.permanent_ess
          when 'join'
            parsed << 'Join Battle'
            @character.join_battle
          when 'rush', 'disengage'
            parsed << pool.titleize
            @character.send(pool.downcase)
          when /m-?a/
            parsed << 'Martial Arts'
            @character.martial_arts
          else
            possible = (Character::ABILITIES + Character::ATTRIBUTES).select do |thing|
              thing.to_s.start_with?(pool.downcase)
            end
            if possible.length > 1
              error!("'#{pool}' is ambiguous; could be #{possible.map(&:to_s)
                                                                     .to_sentence(two_words_connector: ' or ',
                                                                                  last_word_connector: ', or')}\\n" \
                     "Please supply more letters", 400)
            elsif possible.empty?
              error!("\\'#{pool}")
            else
              parsed << possible[0].to_s.titleize
              @character.send(possible[0])
            end
          end
        ]
      end.merge('penalty'     => @character.hl_penalty,
                'parsed_pool' => parsed.join(' + '),
                'char_name'   => @character.name)
    end

    post :pay do
      amount = -params[:amount].to_i
      adjust(params[:resource], amount)
    end
    post :gain do
      amount = params[:amount].to_i
      adjust(params[:resource], amount)
    end
  end
end
