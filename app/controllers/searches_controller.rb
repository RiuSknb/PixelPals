class SearchesController < ApplicationController
  def search
    @query = params[:query]
    @category = params[:category]
    @match_type = params[:match_type] # "exact"（完全一致）か"partial"（部分一致）

    case @category
    when "games"
      @results = Game.where("name LIKE ?", "%#{@query}%")
    when "diaries"
      @results = Diary.where("title LIKE ? OR body LIKE ?", "%#{@query}%", "%#{@query}%")
    when "users"
      @results = User.where("name LIKE ?", "%#{@query}%")
    else
      @results = []
    end

    render :result
  end

  private

  def search_by_match_type(model, column, query, match_type)
    case match_type
    when "exact"
      model.where("#{column} = ?", query)
    when "partial"
      model.where("#{column} LIKE ?", "%#{query}%")
    else
      model.none
    end
  end
end