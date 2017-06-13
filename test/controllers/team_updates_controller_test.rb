require 'test_helper'

class TeamUpdatesControllerTest < ActionController::TestCase

	test "index works" do
		get :index
		assert_response :success
	end

	test "new works" do
		get :new
		assert_response :success
	end

end
