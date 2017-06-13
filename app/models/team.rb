class Team < ActiveRecord::Base
	has_many :projects
	has_many :team_updates
	has_many :work_items
	belongs_to :parent, :class_name => 'Team', :foreign_key => 'parent_team_id'
  	has_one :children, :class_name => 'Team', :foreign_key => 'parent_team_id'

	validate :not_parent_of_self


	def self.selector

		#Build an array of pairs as expected by a form dropdown
		results = Array.new

		Team.all.each do |t|
			rec = Array.new
			rec.push t.name
			rec.push t.id
			results.push rec
		end

		return results.sort
	end

	def self.sortedCategories
		teams = Team.all.to_a
		teams.sort!{|a,b| a.scopedName.downcase <=> b.scopedName.downcase }
	end

	def self.bipCollection
		hashTeams = Hash.new()
		hashTeams[""] = "(none)"
		sortedCategories.each do |team|
			hashTeams[team.id] = team.name
		end
		return hashTeams
	end

	def scopedName
		scopedName = name
		parent_id = parent_team_id

		while !parent_id.nil?
			parent_team = Team.find_by "id = ?", parent_id
			if parent_team.nil?
				parent_id = nil
			else
				scopedName = parent_team.name + " > " + scopedName
				parent_id = parent_team.parent_team_id
			end
		end
		return scopedName
	end

	def not_parent_of_self
		errors.add(:parent_team_id, "can't be a parent of itself") if id == parent_team_id
	end

end
