require 'json'

class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:destroy, :edit]

  def index
    all_comments = @post.comments.order("created_at DESC").to_json
    if all_comments
      render json: all_comments, status: :ok
    else
      render json: {}, status: :internal_server_error
    end
  end

  def create
    @comment = @post.comments.create(comment: params[:comment])
    # redirect_to post_path(@post)
    if @comment
      render json: { post_slug: @comment.post.slug,
                     post_id: @comment.post.id,
                     comment_id: @comment.id }, status: :ok
    else
      render json: {}, status: :internal_server_error
    end
  end

  def edit
    if @comment.update(comment: params[:comment])
      render json: {}, status: :ok
    else
      render json: {}, status: :internal_server_error
    end
  end

  def destroy
    @comment.destroy
    render json: {}, status: :ok
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end
end
