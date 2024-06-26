class Public::GroupsController < ApplicationController
  before_action :ensure_logged_in, only: [:show]
  before_action :set_group, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    if params[:search]
      @groups = Group.where("title LIKE ?", "%#{params[:search]}%").page(params[:page])
      @group_title = "「#{params[:search]}」の検索結果"
    elsif params[:genre_search]
      @groups = Group.where(genre_id: params[:genre_search]).page(params[:page])
      @group_title = "ジャンル：#{Genre.find(params[:genre_search]).name}"
    else
      @groups = Group.page(params[:page])
    end
    @genres = Genre.all
    @group = Group.new
  end

  def create
    @group = current_user.groups.build(group_params.merge(owner_id: current_user.id, genre_id: params[:group][:genre_id]))
    if @group.save
      @group.members.create(user_id: current_user.id)
      flash[:notice] = "グループを作成しました。"
      redirect_to group_path(@group)
    else
      @groups = Group.page(params[:page])
      @genres = Genre.page(params[:page])
      flash.now[:error] = "グループの作成に失敗しました。"
      render :index
    end
  end

  def show
    if params[:thread_search].present?
      @post_threads = PostThread.where("title LIKE ?", "%#{params[:thread_search]}%").page(params[:page]).per(10)
    else
      @post_threads = @group.post_threads.reverse_order.page(params[:page]).per(10)
    end
    @post_thread = PostThread.new
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "グループを編集しました。"
      redirect_to groups_path
    else
      flash.now[:error] = "グループの編集に失敗しました。"
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).permit(:title, :body, :group_image, :genre_id)
  end

  def ensure_logged_in
    redirect_to new_user_session_path unless user_signed_in?
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_correct_user
    redirect_to groups_path unless @group.owner_id == current_user.id
  end
end
