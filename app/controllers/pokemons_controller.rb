class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all
  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    pokemon = Pokemon.new(pokemon_params)
    pokemon.health = 100
    pokemon.level = 1
    pokemon.trainer = current_trainer
    id = current_trainer[:id]
    if pokemon.valid?
      pokemon.save
      redirect_to  "/trainers/#{id}"
    else
      redirect_to "/new"
      flash[:error] = pokemon.errors.full_messages.to_sentence
    end
  end

  def capture
    pokemon = Pokemon.find(params[:id])
    pokemon.trainer = current_trainer
    pokemon.save 
    redirect_to root_path
  end

  def damage
    pokemon = Pokemon.find(params[:id])
    pokemon.health = pokemon.health - 10
    id = pokemon.trainer_id
    if pokemon.health <= 0
      pokemon.destroy
    else
      pokemon.save
    end
    redirect_to "/trainers/#{id}"
  end

  private
    # Using a private method to encapsulate the permissible parameters
    # is just a good pattern since you'll be able to reuse the same
    # permit list between create and update. Also, you can specialize
    # this method with per-user checking of permissible attributes.
    def pokemon_params
      params.require(:pokemon).permit(:name, :ndex)
    end
end
