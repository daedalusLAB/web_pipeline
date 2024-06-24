class WelcomeController < ApplicationController
  
  def index
    # if user is not logged in, only show public post
    if user_signed_in?
      @posts = Post.where(published: true )
                  .order(order: :asc)
    else
      @posts = Post.where(published: true, private: false)
                  .order(order: :asc)
    end
  end

  def faq
  end
end
