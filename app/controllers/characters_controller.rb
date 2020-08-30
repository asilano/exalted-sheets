class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
  end

  # GET /characters/new
  def new
    @character = Character.new(discord_user: params[:discord_user])
    @character.health_levels = [0, -1, -1, -2, -2, -4, -4].map do |pen|
      HealthLevel.new(penalty: pen)
    end
    8.times { |_| @character.health_levels.build }
  end

  # GET /characters/1/edit
  def edit
    (15 - @character.health_levels.count).times { |_| @character.health_levels.build }
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)

    respond_to do |format|
      if @character.save
        format.html { redirect_to edit_character_path(@character), notice: 'Character was successfully created.' }
        format.json { render :show, status: :created, location: @character }
      else
        format.html { render :new }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to edit_character_path(@character), notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy
    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_character
    @character = Character.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def character_params
    params.require(:character).permit(:discord_user,
                                      :name,
                                      :spark,
                                      :player_name,
                                      :caste,
                                      :concept,
                                      :anima,
                                      :supernal,
                                      :lineage,
                                      *Character::ATTRIBUTES,
                                      *Character::ABILITIES,
                                      *Character::ABILITIES.map { |a| "favoured_#{a}" },
                                      :remaining_wp,
                                      :permanent_wp,
                                      :limit_break,
                                      :permanent_ess,
                                      :remaining_personal_ess,
                                      :remaining_periph_ess,
                                      :committed_ess,
                                      :limit_trigger,
                                      :unspent_xp,
                                      :total_xp,
                                      :unspent_spark_xp,
                                      :total_spark_xp,
                                      specialties_attributes: %i[
                                        id
                                        ability
                                        situation
                                        _destroy
                                      ],
                                      merits_attributes: %i[
                                        id
                                        name
                                        rating
                                        _destroy
                                      ],
                                      weapons_attributes: %i[
                                        id
                                        name
                                        accuracy
                                        damage
                                        defence
                                        overwhelming
                                        tags
                                        tags_string
                                        wielded
                                        _destroy
                                      ],
                                      armours_attributes: %i[
                                        id
                                        name
                                        soak
                                        hardness
                                        mobility_penalty
                                        tags
                                        tags_string
                                        _destroy
                                      ],
                                      health_levels_attributes: %i[
                                        id
                                        penalty
                                        _destroy
                                      ],
                                      intimacies_attributes: %i[
                                        id
                                        variety
                                        name
                                        intensity
                                        _destroy
                                      ]
                                     )
  end
end
