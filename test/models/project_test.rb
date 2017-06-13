require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
	test "Last Week, Last Year" do
		dateFirstWeek = Date.new(2014, 1, 6)
		lastWeekLastYear = Project.lastWeek( dateFirstWeek )
		assert_equal( 2013, lastWeekLastYear.year, "Year mismatch" )
		assert_equal( 12, lastWeekLastYear.month, "Month mismatch" )
		assert_equal( 30, lastWeekLastYear.day, "Day mismatch" )
	end
end
