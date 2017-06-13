module DateManagement
	def get_date_params(params)
		today = Date.today
		year = params.has_key?(:year) ? params[:year].to_i : today.year
		week = params.has_key?(:week) ? params[:week].to_i :
			(year < today.year ? Date.new( year, 12, 31).cweek : [1, today.cweek].max)

		if !params.has_key?(:week) && !params.has_key?(:year)
			week, year = WeekMath.last_week( week, year )
		end
		return today, year, week
	end
end
