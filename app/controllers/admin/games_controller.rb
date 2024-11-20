class Admin::GamesController < ApplicationController
  def new
  end

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end