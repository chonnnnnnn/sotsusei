class PostsController < ApplicationController
  before_action :authenticate_user!

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

  private

  def post_params
    params.require(:post).permit(:post_type, :date, :name, :prefecture, :genre, :repeat_intention, :memo, :image)
  end
end
