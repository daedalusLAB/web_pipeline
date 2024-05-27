class WelcomeController < ApplicationController
  
  def index
    # get all post with published top true order by order
    @posts = Post.where(published: true)
                  .order(order: :asc)
  end
end
