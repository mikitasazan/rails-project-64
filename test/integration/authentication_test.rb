# frozen_string_literal: true

require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "#sign_up creates a user and signs them in" do
    email = Faker::Internet.unique.email
    attrs = { email:, password: "password123", password_confirmation: "password123" }

    assert_difference -> { User.count }, 1 do
      post user_registration_path, params: { user: attrs }
    end

    assert_response :redirect
    assert { User.exists?(email:) }
    assert { User.find_by(email:).valid_password?(attrs[:password]) }

    follow_redirect!
    assert_response :success
    assert { path == root_path }
  end

  test "#sign_up with mismatched password confirmation fails" do
    attrs = { email: Faker::Internet.unique.email,
              password: "password123",
              password_confirmation: "other" }

    assert_no_difference -> { User.count } do
      post user_registration_path, params: { user: attrs }
    end

    assert_response :unprocessable_entity
  end

  test "#sign_in with valid credentials" do
    attrs = { email: Faker::Internet.unique.email, password: "password123" }
    User.create!(attrs)

    post user_session_path, params: { user: attrs }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert { path == root_path }
  end

  test "#sign_in with wrong password fails" do
    attrs = { email: Faker::Internet.unique.email, password: "password123" }
    User.create!(attrs)

    post user_session_path, params: { user: { email: attrs[:email], password: "wrong-password" } }

    assert_response :unprocessable_entity
  end

  test "#sign_out" do
    attrs = { email: Faker::Internet.unique.email, password: "password123" }
    User.create!(attrs)

    post user_session_path, params: { user: attrs }
    delete destroy_user_session_path

    assert_response :redirect
    follow_redirect!
    assert { path == root_path }
  end
end
