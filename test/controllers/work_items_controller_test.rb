require 'test_helper'

class WorkItemsControllerTest < ActionController::TestCase
	setup do
		@work_item = work_items(:one)
	end

	test "index works" do
		get :index
		assert_response :success
		assert_not_nil assigns(:work_items)
	end

	test "show works" do
		get :show, :id => @work_item.id
		assert_response :success
		assert( @work_item.item_key == work_items(:one)[:item_key],
			@work_item.item_key + " does not equal " + work_items(:one)[:item_key] )
		assert( @work_item.summary == work_items(:one)[:summary],
			@work_item.summary + "does not equal " + work_items(:one)[:summary] )
	end

	test "edit works" do
		get :edit, :id => @work_item.id
		assert_response :success
		assert( @work_item.item_key == work_items(:one)[:item_key],
			@work_item.item_key + " does not equal " + work_items(:one)[:item_key] )
		assert( @work_item.summary == work_items(:one)[:summary],
			@work_item.summary + " does not equal " + work_items(:one)[:summary] )
	end
end
