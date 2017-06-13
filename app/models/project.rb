class Project < ActiveRecord::Base
	belongs_to :team
	validates :title, presence: true, length: { minimum: 5 }

	scope :current, lambda { where('start_date <= ? AND end_date >= ? AND start_date IS NOT NULL AND end_date IS NOT NULL', Date.today , Date.today).order('start_date') }
	scope :future, lambda { where('start_date > ? AND start_date IS NOT NULL', Date.today).order('start_date') }
	scope :completed, lambda { where('end_date < ? AND start_date IS NOT NULL AND end_date IS NOT NULL', Date.today).order('end_date desc')}

	def self.weeksInYear( year )
		Date.new(year, 12, 28).cweek
	end

	def self.nextWeek( date = nil )
		date = date.nil? ? Date.today : date
		weeksInYear = self.weeksInYear( date.year )
		week_next = date.cweek < weeksInYear ? date.cweek + 1 : 1
		year_next = date.cweek < weeksInYear ? date.year : date.year + 1
		return Date.commercial( year_next, week_next, 1)
	end

	def self.lastWeek( date = nil )
		date = date.nil? ? Date.today : date
		week_previous = date.cweek > 1 ? date.cweek - 1 : self.weeksInYear( date.cwyear - 1 )
		year_previous = date.cweek > 1 ? date.cwyear : date.cwyear - 1
		return Date.commercial( year_previous, week_previous, 1)
	end

	def weeks( selectors = ['All Weeks'] )

		startDate = start_date.nil? ? Date.today : start_date
		endDate = end_date.nil? ? Date.today : end_date
		currentWeek = Date.commercial( Date.today.year, Date.today.cweek, 1)

		weeks = selectors.flat_map{| s | map_selector( s, startDate, endDate, currentWeek )}
	end

	def weeks_invested
		start = start_date.nil? ? Date.today : start_date
		((Date.today - start)/7).to_i
	end

	private

	def map_selector( selector, startDate, endDate, currentWeek )
		weeks = Array.new
		if selector == 'All Weeks'
			(startDate.year..endDate.year).each do |y|
				wk_start = (startDate.year == y) ? startDate.cweek : 1
				wk_end = (endDate.year == y) ? endDate.cweek : Project.weeksInYear( y )

				(wk_start..wk_end).each do |w|
					weeks << Date.commercial(y,w,1)
				end
			end
		elsif selector == 'This Week' && currentWeek >= startDate and currentWeek <= endDate
			weeks << currentWeek
		elsif selector == 'Next Week'
			weeks << Project.nextWeek
		elsif selector == 'Last Week'
			weeks << Project.lastWeek
		elsif selector.to_s.strip.length == 0
		else
			weeks << Date.strptime(selector, "%Y-%m-%d")
		end

		return weeks

	end
end
