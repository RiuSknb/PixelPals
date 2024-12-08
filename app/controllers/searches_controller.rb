class SearchesController < ApplicationController
  def search
    @query = params[:query]

    if @query.present?
      # 検索クエリがある場合に各モデルを検索
      @games = Game.where("name LIKE ?", "%#{@query}%")
      @diaries = Diary.where("title LIKE ? OR body LIKE ?", "%#{@query}%", "%#{@query}%")
      @users = User.where("name LIKE ?", "%#{@query}%")
      @events = Event.where("title LIKE ?", "%#{@query}%")
    else
      # 検索クエリが空の場合は空の結果を返す
      @games = []
      @diaries = []
      @users = []
      @events = []
    end

    render :result
    
  end
end