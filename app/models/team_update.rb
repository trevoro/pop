class TeamUpdate < ActiveRecord::Base
	belongs_to :team, :counter_cache => true

	scope :in_week, lambda { |week|
		if week > 0
			where('week = ?', week )
		end
	}
	scope :in_year, lambda { |year| where('year = ?', year)}
end
