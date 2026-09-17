# frozen_string_literal: true

require "test_helper"

class PostsTest < ActionDispatch::IntegrationTest
  test "#index shows all posts" do
    get root_path

    assert_response :success
    assert { @response.body.include?(posts(:one).title) }
  end

  test "#show shows a post" do
    get post_path(posts(:one))

    assert_response :success
    assert { @response.body.include?(posts(:one).title) }
  end

  test "#new requires authentication" do
    get new_post_path

    assert_redirected_to new_user_session_path
  end

  test "#create requires authentication" do
    post posts_path, params: { post: { title: "x" } }

    assert_redirected_to new_user_session_path
  end

  test "#create by signed-in user" do
    sign_in_as users(:one)
    attrs = { title: "Post about testing",
              body: Faker::Lorem.paragraph(sentence_count: 25),
              category_id: categories(:one).id }

    assert_difference -> { Post.count }, 1 do
      post posts_path, params: { post: attrs }
    end

    saved = Post.find_by!(title: attrs[:title])
    assert { saved.creator == users(:one) }
    assert { saved.body == attrs[:body] }
    assert_redirected_to post_path(saved)
  end

  test "#create with invalid data fails" do
    sign_in_as users(:one)

    assert_no_difference -> { Post.count } do
      post posts_path, params: { post: { title: "hi", body: "too short", category_id: categories(:one).id } }
    end

    assert_response :unprocessable_entity
  end

  private

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: "password123" } }
  end
end
