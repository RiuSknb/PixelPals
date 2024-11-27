class Admin::GamesController < Admin::BaseController
  def new
    @game = Game.new
  end

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to admin_games_path, notice: 'ジャンルを登録しました。'
    else
      render :new
    end
  end

  def edit
    @game = Game.find(params[:id])
    @genres = Genre.all
  end

  def update
    @game = Game.find(params[:id])
    @genres = Genre.all
    if @game.update(game_params)
      redirect_to admin_game_path(@game), notice: 'ゲームが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :genre_id)
  end
end