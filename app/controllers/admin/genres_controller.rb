class Admin::GenresController < Admin::BaseController
  def new
  end

  def index
    @genres = Genre.all
  end

  def show
  end

  def create
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: 'ゲームが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path, notice: 'ゲームが削除されました。'
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
