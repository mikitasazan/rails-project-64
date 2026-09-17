# frozen_string_literal: true

require "test_helper"

class CommentsTest < ActionDispatch::IntegrationTest
  test "#create by signed-in user adds a comment" do
    sign_in_as users(:one)

    assert_difference -> { PostComment.count }, 1 do
      post post_comments_path(posts(:one)),
           params: { post_comment: { content: "A fresh comment on the post" } }
    end

    assert_redirected_to post_path(posts(:one))
    assert { users(:one).comments.exists?(content: "A fresh comment on the post") }
  end

  test "#create reply nests the comment under its parent" do
    sign_in_as users(:two)

    post post_comments_path(posts(:one)),
         params: { post_comment: { content: "A nested reply for the tree", parent_id: post_comments(:one).id } }

    reply = PostComment.find_by!(content: "A nested reply for the tree")
    assert { reply.parent == post_comments(:one) }
  end

  test "#create requires authentication" do
    post post_comments_path(posts(:one)), params: { post_comment: { content: "Guest comment" } }

    assert_redirected_to new_user_session_path
  end

  test "#create with too short content fails" do
    sign_in_as users(:one)

    assert_no_difference -> { PostComment.count } do
      post post_comments_path(posts(:one)), params: { post_comment: { content: "hi" } }
    end

    assert_redirected_to post_path(posts(:one))
  end

  test "post page shows the comment section with tree" do
    sign_in_as users(:one)
    get post_path(posts(:one))

    assert_response :success
    assert { @response.body.include?(post_comments(:one).content) }
    assert { @response.body.include?(post_comments(:nested).content) }
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: "password123" } }
  end
end
