class Public::HomesController < ApplicationController
  def top
    @recent_events = Event.order(created_at: :desc).limit(5) # 最新の5件を取得
    @recent_diaries = Diary.order(created_at: :desc).limit(5)
    @recent_groups = Group.order(created_at: :desc).limit(5)
  end

  def about
  end
end
