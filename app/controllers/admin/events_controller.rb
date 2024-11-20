class Admin::EventsController < Admin::BaseController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.where(is_deleted: false).order(created_at: :desc)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to admin_event_path(@event), notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
  end

  private
  
  def event_params
    params.require(:event).permit(:title, :body, :place, :date, :user_id, :game_id, :genre_id, :group_id)
  end

end
