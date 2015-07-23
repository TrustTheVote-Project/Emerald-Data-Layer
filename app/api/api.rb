class API < Grape::API
	prefix 'api'
	version 'v1', using: :path
	format :json


	# API. Follow following custom to access:
	# resource :hello do
	# ...
	# post :greetings do
	# ...
	# URL for curl would be post .../api/v1/hello/greetings
	# If just post do, then .../api/v1/hello


	# Jurisdiction methods
	resource :jurisdiction do

		desc "List jurisdictions"
		get do
			# return list of name, ID of each jurisdiction

			# dummy message for testing
			"OK"
		end

		desc "List districts under a jurisdiction"
		params do
			requires :object_id, type: String
		end
		post :list_districts do
			# list districts attached to given jurisdiction

			# dummy message for testing
			['DISTRICT_1', 'DISTRICT_2', 'DISTRICT_3']
		end

		desc "List all subunits of a jurisdiction, such as listing counties and districts of a state"
		params do
			requires :object_id, type: String
		end
		post :list_subunits do
			# list all subunits

			# dummy message for testing
			['COUNTY_1', 'DISTRICT_1', 'DISTRICT_2']
		end

		desc "Create new jurisdiction, manually inputting parameters."
		params do
			requires :object_id, type: String
			requires :type, type: String
		end
		post :create do
			# create jurisdiction
			# params allowed are those defined in VSSC for ReportingUnit

			# dummy message for testing
			"creating jurisdiction"
		end

		desc "Import jurisdiction"
		params do
			# only the data string
			requires :info, type: String
		end
		post :import do
			# parse and create jurisdiction
		end

		desc "Display full info on selected jurisdiction"
		params do
			requires :object_id, type: String
		end
		post :read do
			# return all data from selected jurisdiction

			# dummy message for testing
			"jurisdiction data"
		end

		desc "Update selected jurisdiction"
		params do
			requires :object_id, type: String
		end
		post :update do
			# update given parameters in selected jurisdiction

			# dummy message for testing
			"updating"
		end

		desc "Attach child to jurisdiction. This can be attaching a jurisdiction to another, such as
		setting a county as a child of a state. This also can be attaching a precinct or district."
		params do
			requires :object_id, type: String
			requires :child_id, type: String
		end
		post :attach do
			# attach to the given jurisdiction

			# dummy message for testing
			"attaching"
		end

		desc "Detach a child element from a jurisdiction."
		params do
			requires :object_id, type: String
			requires :child_id, type: String
		end
		post :detach do
			# detach the current child

			# dummy message for testing
			"attaching"
		end
	end

	# Precinct methods
	resource :precinct do
		desc "List all precincts"
		post do
			# list precints

			# dummy message for testing
			['PRECINCT_1', 'PRECINCT_2', 'PRECINCT_3']
		end

		desc "Create precinct"
		params do
			requires :object_id, type: String
		end
		post :create do
			# create precinct

			# dummy message for testing
			"creating precinct"
		end

		desc "Display full info on selected precinct"
		params do
			requires :object_id, type: String
		end
		post :read do
			# display selected precinct info

			# dummy message for testing
			"precinct info"
		end

		desc "Update selected precinct"
		params do
			requires :object_id, type: String
		end
		post :update do
			# update selected precinct

			# dummy message for testing
			"updated"
		end
	end

	# District methods
	resource :district do
		desc "List all districts"
		get do
			# list districts

			# dummy message for testing
			['DISTRICT_1', 'DISTRICT_2', 'DISTRICT_3']
		end

		desc "List precincts attached to a district"
		params do
			requires :object_id, type: String
		end
		post :list_precincts do
			# list precincts attached to district from jurisdiction

			# dummy message for testing
			['PRECINCT_1', 'PRECINCT_2', 'PRECINCT_3']
		end

		desc "Create district"
		params do
			requires :object_id, type: String
		end
		post :create do
			# create precinct and attach it to jurisdiction

			# dummy message for testing
			"creating district"
		end

		desc "Display district info"
		params do
			requires :object_id, type: String
		end
		post :read do
			# display info on the district

			# dummy message for testing
			"district info"
		end

		desc "Update district"
		params do
			# not sure if jurisdiction ID is needed
			requires :object_id, type: String
		end
		post :update do
			# update info for the district

			# dummy message for testing
			"updating district"
		end

		desc "Attach a precinct to a district"
		params do
			requires :object_id, type: String
			requires :precinct_id, type: String
		end
		post :attach_precinct do
			# attach precinct to district

			# dummy message for testing
			"attaching precinct " + params[:precinct_id] + " to district " + params[:object_id]
		end
	end

	resource :election do
		desc "List all elections"
		get do
			# list elections under given jurisdiction

			# dummy message for testing
			"elections"
		end

		desc "List all elections under a certain scope"
		params do
			requires :jurisdiction_id, type: String
		end
		post do
			# list elections under given jurisdiction

			# dummy message for testing
			"elections under " + params[:jurisdiction_id]
		end

		desc "Create new election"
		params do
			requires :date_month, type: Integer
			requires :date_day, type: Integer
			requires :date_year, type: Integer
			requires :election_type, type: String
			requires :name, type: String
		end
		post :create do
			# create a new election

			# dummy message for testing
			"creating election"
		end

		desc "Detail one election"
		params do
			requires :object_id, type: String
		end
		post :read do
			# detail selected election

			# dummy message for testing
			"election"
		end

		desc "Update one election"
		params do
			requires :object_id, type: String
		end
		post :update do
			# update selected election

			# dummy message for testing
			"updating"
		end
	end

	resource :candidate_contest do
		desc "List all candidate contests under an election"
		params do
			requires :election_id, type: String
		end
		post do
			# list all candidate contests

			# dummy message for testing
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end

		desc "Create candidate contest"
		params do
			requires :name, type: String
			requires :election_id, type: String
			requires :votes_allowed, type: Integer

			# vssc allows for more than one scope ID, but requires at least 1
			# not sure if this is the right way to do this
			requires :jurisdiction_scope_id, type: Array
		end
		post :create do
			# create the candidate contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a candidate contest"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :read do
			# detail the selected contest

			# dummy message for testing
			"candidate contest"
		end

		desc "Update candidate contest"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating candidate contest"
		end

		desc "Attach an office to contest"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
			requires :office_id, type: String
		end
		post :attach_office do
			# attach the office

			# dummy message for testing
			"adding office to contest"
		end
	end

	resource :candidate do
		desc "List all candidates in an election"
		params do
			requires :election_id, type: String
		end
		post do
			# list all candidates

			# dummy message for testing
			['CANDIDATE_1', 'CANDIDATE_2', 'CANDIDATE_3']
		end

		desc "Create a candidate"
		params do
			requires :object_id, type: String
			requires :election_id, type: String
			requires :ballot_name, type: String
		end
		post :create do
			# create candidate

			# dummy message for testing
			"creating candidate " + params[:ballot_name]
		end

		desc "Detail a candidate"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :read do
			# detail the candidate

			# dummy message for testing
			"candidate"
		end

		desc "Update a candidate"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :update do
			# update the candidate

			# dummy message for testing
			"updating candidate"
		end
	end

	resource :party do
		desc "List all parties"
		get do
			# list all defined parties

			# dummy message for testing
			['PARTY_1', 'PARTY_2', 'PARTY_3']
		end

		desc "Create a new party"
		params do
			requires :object_id, type: String
			requires :name, type: String
		end
		post :create do
			# create party

			# dummy message for testing
			"creating party " + params[:name]
		end

		desc "Detail a party"
		params do
			requires :object_id, type: String
		end
		post :read do
			# detail party

			# dummy message for testing
			"party"
		end

		desc "Update a party"
		params do
			requires :object_id, type: String
		end
		post :update do
			# update party

			# dummy message for testing
			"updating party"
		end
	end

	resource :ballot_measure_contest do
		desc "List all ballot measure contests"
		params do
			requires :election_id, type: String
		end
		post do
			# list all candidate contests

			# dummy message for testing
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end

		desc "Create ballot measure contest"
		params do
			requires :name, type: String
			requires :election_id, type: String
			requires :ballot_measure_type, type: String

			# vssc allows for more than one scope ID, but requires at least 1
			# not sure if this is the right way to do this
			requires :jurisdiction_scope_id, type: Array
		end
		post :create do
			# create the ballot measure contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a ballot measure contest"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :read do
			# detail the selected contest

			# dummy message for testing
			"ballot measure contest"
		end

		desc "Update ballot measure contest"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating ballot measure contest"
		end
	end

	resource :ballot_measure_selection do
		desc "List all ballot measure selections for a contest"
		params do
			requires :election_id, type: String
			requires :contest_object_id, type: String
		end
		post do
			# list selections for a contest

			# dummy message for testing
			['SELECTION_1', 'SELECTION_2']
		end

		desc "Create a ballot measure selection"
		params do
			requires :election_id, type: String
			requires :contest_object_id, type: String
			requires :selection, type: String
		end
		post :create do
			# create a ballot measure selection

			# dummy message for testing
			"creating selection " + params[:selection] + " in contest " + params[:object_id]
		end

		desc "Detail a ballot measure selection"
		params do
			requires :election_id, type: String
			requires :contest_object_id, type: String
			requires :selection_object_id, type: String
		end
		post :read do
			# detail the selected selection

			# dummy message for testing
			"selection"
		end

		desc "Update a ballot measure selection"
		params do
			requires :election_id, type: String
			requires :contest_object_id, type: String
			requires :selection_object_id, type: String
		end
		post :update do
			# update the selected selection

			# dummy message for testing
			"updating"
		end
	end

	resource :contest do
		desc "List all contests under a certain election, both candidate and ballot measure"
		params do
			requires :election_id, type: String
		end
		post do
			# return all contests

			# dummy message for testing
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end
	end

	resource :ballot_style do
		desc "List all ballot styles of an election"
		params do
			requires :election_id, type: String
		end
		post do
			# return all ballot styles of that election

			# dummy message for testing
			['STYLE_1', 'STYLE_2', 'STYLE_3']
		end

		desc "Create a new ballot style"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
			requires :gpunit_id, type: String
		end
		post :create do
			# create a new ballot style

			# dummy message for testing
			"creating new ballot style"
		end

		desc "Detail a ballot style"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :read do
			# detail the selected ballot style

			# dummy message for testing
			"ballot style"
		end

		desc "Update a ballot style"
		params do
			requires :election_id, type: String
			requires :object_id, type: String
		end
		post :update do
			# update the selected ballot style

			# dummy message for testing
			"updating"
		end
	end

	resouce :ordered_contest do
		desc "List all ordered contests"
		params do
			requires :election_id, type: String
			requires :ballot_style_id, type: String
		end
		post do
			# list all ordered contests

			# dummy message for testing
			['CANDIDATE_1', 'CANDIDATE_2', 'CANDIDATE_3']
		end

		desc "Create an ordered contest"
		params do
			requires :election_id, type: String
			requires :ballot_style_id, type: String
			requires :object_id, type: String
			requires :contest_id, type: String
		end
		post :create do
			# create an ordered contest

			# dummy message for testing
			"creating ordered contest"
		end

		desc "Detail an ordered contest"
		params do
			requires :election_id, type: String
			requires :ballot_style_id, type: String
			requires :object_id, type: String
		end
		post :read do
			# detail the ordered contest

			# dummy message for testing
			"ordered contest"
		end

		desc "Update an ordered contest"
		params do
			requires :election_id, type: String
			requires :ballot_style_id, type: String
			requires :object_id, type: String
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating ordered contest"
		end

	resource :office do
		desc "List all offices"
		get do
			# list all offices

			# dummy message for testing
			['OFFICE_1', 'OFFICE_2', 'OFFICE_3']
		end

		desc "Create a new office"
		params do
			requires :object_id, type: String
			requires :name, type: String
		end
		post :create do
			# create a new office

			# dummy message for testing
			"creating new office"
		end

		desc "Detail an office"
		params do
			requires :object_id, type: String
		end
		post :read do
			# detail the office

			# dummy message for testing
			"office"
		end

		desc "Update an office"
		params do
			requires :object_id, type: String
		end
		post :update do
			# update the office

			# dummy message for testing
			"updating the office"
		end
	end

end