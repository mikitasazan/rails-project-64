# frozen_string_literal: true

require "test_helper"

class LikesTest < ActionDispatch::IntegrationTest
  test "#create by signed-in user adds a like" do
    sign_in_as users(:one)

    assert_difference -> { posts(:one).likes.reload.count }, 1 do
      post post_likes_path(posts(:one))
    end

    assert_redirected_to post_path(posts(:one))
    assert { users(:one).likes.exists?(post: posts(:one)) }
    assert { posts(:one).reload.likes_count == 1 }
  end

  test "#create twice keeps one like" do
    sign_in_as users(:one)

    post post_likes_path(posts(:one))
    post post_likes_path(posts(:one))

    assert { users(:one).likes.count == 1 }
  end

  test "#create requires authentication" do
    post post_likes_path(posts(:one))

    assert_redirected_to new_user_session_path
  end

  test "#destroy removes own like" do
    sign_in_as users(:one)
    like = users(:one).likes.create!(post: posts(:one))

    delete post_like_path(posts(:one), like)

    assert_redirected_to post_path(posts(:one))
    assert { PostLike.exists?(like.id) == false }
  end

  test "#destroy of someone else's like does nothing" do
    sign_in_as users(:one)
    foreign = post_likes(:one)

    delete post_like_path(posts(:one), foreign)

    assert_redirected_to post_path(posts(:one))
    assert { PostLike.exists?(foreign.id) }
  end

  test "post page shows like counter and button" do
    sign_in_as users(:one)
    users(:one).likes.create!(post: posts(:one))
    get post_path(posts(:one))

    assert_response :success
    assert { @response.body.include?("Понравилось: 1") }
    assert { @response.body.include?('aria-label="Лайк"') }
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: "password123" } }
  end
end
