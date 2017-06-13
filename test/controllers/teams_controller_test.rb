require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
	setup do
		@team = teams(:one)
	end

	test "index works" do
		get :index
		assert_response :success
		assert_not_nil assigns(:teams)
	end

	test "new works" do
		get :new
		assert_response :success
		assert_not_nil assigns(:team)
	end

	test "edit works" do
		get :edit, :id => @team.id
		assert_response :success
		assert_not_nil assigns(:team)
		assert( @team.name == teams(:one)[:name] )
		assert( @team.description == teams(:one)[:description] )
	end

	test "show works" do
		get :show, :id => @team.id
		assert_response :success
		assert_not_nil assigns(:team)
		assert( @team.name == teams(:one)[:name] )
		assert( @team.description == teams(:one)[:description] )
	end

end
