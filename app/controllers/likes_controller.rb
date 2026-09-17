# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    authenticate_user!
    post = Post.find(params.expect(:post_id))

    post.likes.find_or_create_by!(user: current_user)

    redirect_to post
  end

  def destroy
    authenticate_user!
    post = Post.find(params.expect(:post_id))

    like = post.likes.find_by(id: params.expect(:id), user: current_user)
    like&.destroy

    redirect_to post
  end
end
