class SearchController < ApplicationController

	def index
		if params[:search].blank?
			@search_key = ""
		else
			@search_key = params[:search]
		end
	    users = User.search(@search_key)
    	projects = Project.search(@search_key)
    	groups = Group.search(@search_key)

    	@users_count = users.count
    	@projects_count = projects.count
    	@groups_count = groups.count
    	@users = users[0..2]
    	@projects = projects[0..2]
    	@groups = groups[0..2]
	end

	def contacts
		@search_key = params[:search_key]
	    @users = User.search(@search_key)
	    @users_count = @users.length
	end

	def projects
		@search_key = params[:search_key]
	    @projects = Project.search(@search_key)
	    @projects_count = @projects.length
	end

	def groups
		@search_key = params[:search_key]
	    @groups = Group.search(@search_key)
	    @groups_count = @groups.length
	end
end