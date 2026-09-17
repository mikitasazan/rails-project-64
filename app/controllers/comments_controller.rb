# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    authenticate_user!
    @post = Post.find(params.expect(:post_id))
    @comment = current_user.comments.build(post_comment_params)
    @comment.post = @post

    if @comment.save
      flash[:success] = t(".success")
    else
      flash[:error] = @comment.errors.first.full_message
    end

    redirect_to @post
  end

  private

  def post_comment_params
    params.expect(post_comment: %i[content parent_id])
  end
end
