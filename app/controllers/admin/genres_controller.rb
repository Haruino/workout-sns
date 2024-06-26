class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_genre, only: [:edit, :update, :destroy]
  
  def index
    @genres = Genre.all
    @genre = Genre.new
  end
  
  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:success] = "ジャンルを作成しました。"
      redirect_to
    else
      @genres = Genre.all
      flash.now[:danger] = "ジャンルの作成に失敗しました。"
      render :index
    end
  end
  
  def edit
  end
  
  def update
    if @genre.update(genre_params)
      flash[:success] = "ジャンルを編集しました。"
      redirect_to admin_genres_path
    else
      flash.now[:danger] = "ジャンルの編集に失敗しました。"
      render :edit
    end
  end
  
  private
  
  def set_genre
    @genre = Genre.find(params[:id])
  end
  
  def genre_params
    params.require(:genre).permit(:name)
  end
end
