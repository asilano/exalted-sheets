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

      def unwield_weapons
        @character.weapons.update(wielded: false)
      end
    end

    get do
      @character || {}
    end

    get :pools do
      parsed = []
      response = params[:pools].to_h do |pool|
        [
          pool.to_sym,
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
          when 'rush', 'disengage', 'parry', 'evasion', 'damage'
            parsed << pool.titleize
            @character.send(pool.downcase)
          when /m-?a/
            parsed << 'Martial Arts'
            @character.martial_arts
          when 'wither'
            parsed << 'Wither'
            @character.wither(range: params[:range] || 'close')
          when 'decisive'
            parsed << 'Decisive'
            @character.decisive(range: params[:range] || 'close')
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
      end
      response.each { |key, value| present key, value }
      present :penalty, @character.hl_penalty
      present :parsed_pool, parsed.join(' + ')
      present :char_name, @character.name
      present :weapon, ActiveModelSerializers::SerializableResource.new(@character.weapons.where(wielded: true).first)
    end

    get :weapons do
      present :char_name, @character.name
      present :weapons, ActiveModelSerializers::SerializableResource.new(@character.weapons)
    end

    post :pay do
      amount = -params[:amount].to_i
      adjust(params[:resource], amount)
    end
    post :gain do
      amount = params[:amount].to_i
      adjust(params[:resource], amount)
    end

    post :wield_weapon do
      unwield_weapons
      weapon = @character.weapons.where(
        Weapon.arel_table[:name].lower.matches(
          "%#{params[:weapon].downcase.gsub(Regexp.union("\\", "%", "_")) { |x| ["\\", x].join }}%"
        )).first
      error!('No weapon with that name', 404) unless weapon

      weapon.update(wielded: true)
      present :char_name, @character.name
      present :weapon, ActiveModelSerializers::SerializableResource.new(weapon)
    end

    post :injure do
      levels = params[:levels].to_i
      damage_type = params[:damage_type].to_sym

      @character.injure(levels, damage_type)
      if @character.save
        {
          'char_name'      => @character.name,
          'damaged_levels' => @character.health_levels.where.not(damaged: :ok).count,
          'new_penalty'    => @character.hl_penalty
        }
      else
        error!("Couldn't update character - #{@character.errors.full_messages.join(', ')}", 400)
      end

    end
  end
end
