require 'test_helper'

describe UsersController do
  describe "index" do
    it "succeeds with many users" do
      # Assumption: there are many users in the DB
      User.count.must_be :>, 0

      get users_path
      must_respond_with :success
    end

    it "succeeds with no users" do
      # Start with a clean slate
      Vote.destroy_all # for fk constraint
      User.destroy_all

      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an extant user" do
      get user_path(User.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus user" do
      # User.last gives the user with the highest ID
      bogus_user_id = User.last.id + 1
      get user_path(bogus_user_id)
      must_respond_with :not_found
    end
  end

  describe "auth_callback" do
    it "logs in an existing user and redirects to the root page" do
      start_count = User.count

      user = users(:snoopy)

      OmniAuth.config.mock_auth[:github] =  OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)

      must_redirect_to root_path

      session[:user_id].must_equal user.id

      User.count.must_equal start_count

    end

    it "creates a new user if a new user logs in with Github" do
      start_count = User.count

      new_user = User.new( username: "player2", provider: "github", email: "game@changer.com", uid: 666)

      login(new_user)

      must_redirect_to root_path

      User.count.must_equal (start_count + 1)

      session[:user_id].must_equal User.last.id

    end

    it "redirects to the root route if given invalid user data" do

      start_count = User.count
      #missing uid
      user = User.new(provider: "github", username: "test_user", email: "test@user.com")

      login(user)
      must_redirect_to root_path
      User.count.must_equal start_count


    end

  end

end
