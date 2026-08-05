class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @post_type = params[:post_type] if Post.post_types.key?(params[:post_type])
    @posts = current_user.posts
    @posts = @posts.where(post_type: @post_type) if @post_type
    @repeat_intentions = []

    case @post_type
    when "eat_out"
      apply_common_search_filters
      @posts = @posts.where(prefecture: params[:prefecture]) if params[:prefecture].present?
      apply_date_range
    when "purchase"
      apply_common_search_filters
      apply_date_range
    else
      @posts = @posts.order(date: :desc)
    end
  end

  def new
    @post = current_user.posts.build
    @post.post_type = params[:post_type] if Post.post_types.key?(params[:post_type])
    @post.date = Date.current
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to new_post_path(post_type: @post.post_type), notice: "投稿を作成しました"
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

  def destroy
    @post.destroy
    redirect_to posts_path(post_type: @post.post_type), notice: "投稿を削除しました"
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def apply_common_search_filters
    @posts = @posts.where("name ILIKE ?", "%#{Post.sanitize_sql_like(params[:name])}%") if params[:name].present?
    @posts = @posts.where(genre: params[:genre]) if Post.genres.key?(params[:genre])
    @repeat_intentions = Array(params[:repeat_intentions]) & Post.repeat_intentions.keys
    @posts = @posts.where(repeat_intention: @repeat_intentions) if @repeat_intentions.any?
  end

  def apply_date_range
    @date_from = parse_date(params[:date_from])
    @date_to = parse_date(params[:date_to])
    @posts = @posts.where(date: @date_from..) if @date_from
    @posts = @posts.where(date: ..@date_to) if @date_to
    @posts = @posts.order(date: :desc)
  end

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue ArgumentError
    nil
  end

  def post_params
    attrs = params.require(:post).permit(:post_type, :date, :name, :prefecture, :genre, :repeat_intention, :memo, :image)
    attrs.delete(:image) if attrs[:image].blank?
    attrs
  end
end
