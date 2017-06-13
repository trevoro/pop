require 'test_helper'

class WeekMathTest < ActiveSupport::TestCase

	test "Last week, relative to first week of 2017" do
		last_week = WeekMath.last_week(1,2017)
		assert_equal(last_week[1], 2016, "Year of last week relative to first week of 2017 is not 2016")
		assert_equal(last_week[0], 52, "Week of last week relative to first week of 2017 is not 52")
	end

	test "Last week, relative to first week of 2016" do
		last_week = WeekMath.last_week(1,2016)
		puts last_week.to_s
		assert_equal(last_week[1], 2015, "Year of last week relative to first week of 2016 is not 2015")
		assert_equal(last_week[0], 53, "Week of last week relative to first week of 2016 is not 53")
	end

end
