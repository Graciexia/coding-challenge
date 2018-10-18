class PostsController < ApplicationController
  def index
    # Return all `Post`

  end

  def new
    @post = Post.new
  end

  def create
    # Add a new `Post` to the database
  end

  def destroy
    # Remove a `Post` from the database
  end
end
