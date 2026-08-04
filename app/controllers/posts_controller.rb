class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @post_type = params[:post_type] if Post.post_types.key?(params[:post_type])
    @posts = current_user.posts.order(date: :desc)
    @posts = @posts.where(post_type: @post_type) if @post_type

    if @post_type == "eat_out"
      @posts = @posts.where(prefecture: params[:prefecture]) if params[:prefecture].present?
      @posts = @posts.where(date: params[:date]) if params[:date].present?
      @posts = @posts.where("name ILIKE ?", "%#{Post.sanitize_sql_like(params[:name])}%") if params[:name].present?
      @posts = @posts.where(repeat_intention: params[:repeat_intention]) if Post.repeat_intentions.key?(params[:repeat_intention])
    elsif @post_type == "purchase"
      @posts = @posts.where(genre: params[:genre]) if Post.genres.key?(params[:genre])
      @posts = @posts.where(date: params[:date]) if params[:date].present?
      @posts = @posts.where(repeat_intention: params[:repeat_intention]) if Post.repeat_intentions.key?(params[:repeat_intention])
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to new_post_path, notice: "投稿を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    attrs = params.require(:post).permit(:post_type, :date, :name, :prefecture, :genre, :repeat_intention, :memo, :image)
    attrs.delete(:image) if attrs[:image].blank?
    attrs
  end
end
