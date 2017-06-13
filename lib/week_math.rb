module WeekMath
	def self.last_week( week, year )
		referenceYear = week == 1 ? year - 1 : year
		maxWeek = Date.new(referenceYear, 12, 28).cweek
		lastWeek = ((week-2) % maxWeek)+1
		lastWeekYear = lastWeek < week ? year : year - 1
		return lastWeek, lastWeekYear
	end

	def self.next_week( week, year)
		maxWeek = Date.new(year, 12, 28).cweek
		nextWeek = (week % maxWeek)+1
		nextWeekYear = nextWeek > week ? year : year + 1
		return nextWeek, nextWeekYear
	end
end
