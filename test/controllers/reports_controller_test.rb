require 'test_helper'

class AnalyticsControllerTest < ActionController::TestCase

	test "get project_effort_by_objective report works" do
		get :project_effort_by_objective
		assert_response :success
		assert_not_nil assigns(:total_effort)
	end

	test "get objectives report works" do
		get :objectives
		assert_response :success
		assert_not_nil assigns(:year)
		assert_not_nil assigns(:week)
	end

	test "get projects report works" do
		get :projects
		assert_response :success
		assert_not_nil assigns(:year)
		assert_not_nil assigns(:week)
	end

	test "get projects_by_week report works" do
		get :projects_by_week
		assert_response :success
	end

	test "get effort_by_objective report works" do
		get :effort_by_objective
		assert_response :success
		assert_not_nil assigns(:year)
		assert_not_nil assigns(:month)
	end

	test "get weekly_summary report works" do
		get :weekly_summary
		assert_response :success
	end

end
