class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").all.order('created_at DESC')
      @search_performed = true
    else
      @posts = Post.all.order("created_at DESC")
      @search_performed = false
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def find_post
    @post = Post.friendly.find(params[:id])
  end
end
