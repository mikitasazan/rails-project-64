# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.includes(:creator, :category).order(id: :desc)
  end

  def show
    @post = Post.find(params.expect(:id))
    @comments = @post.comments.includes(:user).arrange(order: { created_at: :desc })
    @form_comment = current_user&.comments&.build
  end

  def new
    authenticate_user!
    @post = Post.new
    @categories = Category.all
  end

  def create
    authenticate_user!
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = t(".success")
      redirect_to @post
    else
      @categories = Category.all
      flash.now[:error] = t(".unprocessable_content")
      render :new, status: :unprocessable_content
    end
  end

  private

  def post_params
    params.expect(post: %i[title body category_id])
  end
end
