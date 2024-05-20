class WelcomeController < ApplicationController
  
  def index
    # get all post with published top true
    @posts = Post.where(published: true)
  end
end
