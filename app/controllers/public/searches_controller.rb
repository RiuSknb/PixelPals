class SearchesController < ApplicationController
  def search
    @query = params[:query]
    @category = params[:category]

    case @category
    when "games"
      @results = Game.where("name LIKE ?", "%#{@query}%")
    when "posts"
      @results = Diary.where("title LIKE ? OR content LIKE ?", "%#{@query}%", "%#{@query}%")
    when "users"
      @results = User.where("name LIKE ?", "%#{@query}%")
    else
      @results = []
    end

    render :result
  end
end