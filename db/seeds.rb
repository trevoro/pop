# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

teams = [ 'Red', 'Blue', 'Green', 'Yello' ]
objectives = [
	['Technical Debt',0],
	['New Feature 1',1],
	['Security',0],
	['Maintenance',1],
	['New Feature 2',1],
	['Billing V3',1],
	['Sign-up Flow',1],
	['Homepage Optimization',1],
	['Partner Integration',1],
	['Deployment Pipeline',0]
]

# Create some teams
teams.each_with_index do |t, i|
	Team.find_or_create_by( id: i, name: t )
end

dateCur = DateTime.now
yearCur = dateCur.year

obj_seed = objectives.size

(1..52).each do |week|
	(1..30).each do |idx|
		obj_idx = rand(obj_seed)
		wi = {week: week, year: yearCur, num_people: rand(3) + 1,
			objective: objectives[obj_idx][0], customer_facing: objectives[obj_idx][1]  }
		work_item = WorkItem.find_or_create_by( id: (week * 100) + idx, item_key: "TKT-" + idx.to_s )
		work_item.update( wi )
	end
end
