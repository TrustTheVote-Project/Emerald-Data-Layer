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



	helpers do


		# Error messages are defined in here
		# Messages with error() come out with the given HTTP code,
		# and have a json body of a single string:
		# {"error":"message"}

		# When a requires in a params fails, it is formatted:
		# "{"error":"object_1 is missing, object_2 is missing"


		# error message for when an object is asked for and it does not exist in the database
		def error_not_found(object_id)
			error!('Object not found: ' + object_id, 404)
		end

		# error message for when creating an object and the ID already exists in another object
		def error_already_exists(object_id)
			error!('Object already exists: ' + object_id, 409)
		end

		# error if object is empty
		# unsure about HTTP code
		def error_empty(object_id)
			error!('Object is empty: ' + object_id, 400)
		end

		# error if object is invalid
		def error_invalid(object_id)
			error!('Object is invalid: ' + object_id, 400)
		end

		# error if validate_string_name returns false
		def error_invalid_input(type, value)
			error!(type + ' is invalid: ' + value, 400)
		end

		# error for if object ID exists, but is not the right type of object for what is expected?

		# error for empty list of items in database?


		# Validation methods

		# validate if string is proper for a name
		# at this time only validates if it is printable
		def validate_string_name(string)
			# inspect adds \ to all nonprintable characters and adds \" at each end
			# so compare to normal string with "\"" added to each end
			if !string_printable(string)
				error_invalid_input("name", string)
			end
		end

		# validate if OCDID is formatted properly

		def validate_ocdid(ocdid)
			if !string_printable(ocdid) || !string_ocdid(ocdid)
				error_invalid_input("ocdid",ocdid)
			end
		end

		# Helpers for validations

		# if string is printable (does not contain any characters that must normally be represented in escape)
		def string_printable(string)
			string.inspect == "\"" + string + "\""
		end

		# if string does not contain strange punctuation that would not work in an OCDID
		def string_ocdid(ocdid)
			str = ['!','"','#','$','%','(',')','*','+',',','-','.','/',':',';','<','=','>','?','@','[','\\',']','`','{','|','}','~']
			!str.any? { |word| ocdid.include?(word) }
		end
	end


	# Jurisdiction methods
	resource :jurisdiction do

		desc "List jurisdictions"
		get do
			# return list of name, ID of each jurisdiction

			# error for empty list of items in database?

			# Flintstones test message
			[['Cobblestone County','COUNTY_Cobblestone_County']]
		end

		desc "List districts under a jurisdiction"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :list_districts do
			# list districts attached to given jurisdiction

			# Flintstones test message
			if params[:object_id] == "COUNTY_Cobblestone_County"
				[['City of Bedrock','DISTRICT_TOWNBE'],['Cobblestone County','DISTRICT_CBLCTY'],['Mineral District','DISTRICT_MINERL']]
			else
				error_not_found(params[:object_id])
			end
		end

		desc "List all subunits of a jurisdiction, such as listing counties and districts of a state"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :list_subunits do
			# list all subunits

			# Flintstones test message
			if params[:object_id] == "COUNTY_Cobblestone_County"
				[['City of Bedrock','DISTRICT_TOWNBE'],['Cobblestone County','DISTRICT_CBLCTY'],['Mineral District','DISTRICT_MINERL']]
			elsif params[:object_id] == "DISTRICT_TOWNBE"
				[['Downtown-001'],['Quarrytown-002']]
			elsif params[:object_id] == "DISTRICT_CBLCTY"
				[['Downtown-001'],['Quarrytown-002'],['QuarryCounty-003'],['County-004']]
			elsif params[:object_id] == "DISTRICT_MINERL"
				[['Quarrytown-002'],['QuarryCounty-003']]
			else
				error_not_found(params[:object_id])
			end
		end

		desc "Create new jurisdiction, manually inputting parameters."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String
			requires :elorg_name, type: String
		end
		post :create do
			validate_string_name(params[:name])
			validate_string_name(params[:elorg_name])
			validate_ocdid(params[:object_id])
			if params[:ocdid] == "COUNTY_Cobblestone_County"
			# error if object already exists
				error_already_exists(params[:ocdid])
			else
				# create jurisdiction
				# params allowed are those defined in VSSC for ReportingUnit
			end
		end

		desc "Import jurisdiction"
		params do
			# only the data string
			requires :info, type: String, allow_blank: false
		end
		post :import do
			# parse and create jurisdiction
		end

		desc "Display full info on selected jurisdiction"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# return all data from selected jurisdiction

			# error if object does not exist
			if params[:object_id] != "COUNTY_Cobblestone_County"
				error_not_found(params[:object_id])
			end

			# dummy message for testing
			"jurisdiction data"
		end

		desc "Update selected jurisdiction"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update given parameters in selected jurisdiction

			# error if object does not exist
			if params[:object_id] != "COUNTY_Cobblestone_County"
				error_not_found(params[:object_id])
			end

			# dummy message for testing
			"updating"
		end

		desc "Attach child to jurisdiction. This can be attaching a jurisdiction to another, such as
		setting a county as a child of a state. This also can be attaching a precinct or district."
		params do
			requires :object_id, type: String, allow_blank: false
			requires :child_id, type: String, allow_blank: false
		end
		post :attach do
			# attach to the given jurisdiction

			# error if object does not exist
			if params[:object_id] != "COUNTY_Cobblestone_County"
				error_not_found(params[:object_id])
			end

			# error if child object does not exist
			if params[:child_id] != "DISTRICT_TOWNBE" && params[:child_id] != "DISTRICT_CBLCTY" && params[:child_id] != "DISTRICT_MINERL" 
				error_not_found(params[:child_id])
			end

			# dummy message for testing
			"attaching"
		end

		desc "Detach a child element from a jurisdiction."
		params do
			requires :object_id, type: String, allow_blank: false
			requires :child_id, type: String, allow_blank: false
		end
		post :detach do

			# error if object does not exist
			if params[:object_id] != "COUNTY_Cobblestone_County"
				error_not_found(params[:object_id])
			elsif params[:child_id] != "DISTRICT_TOWNBE" && params[:child_id] != "DISTRICT_CBLCTY" && params[:child_id] != "DISTRICT_MINERL" 
				# error if child object does not exist
				error_not_found(params[:child_id])
			else
				# detach the current child

				# dummy message for testing
				"detaching"
			end
		end
	end

	# Precinct methods
	resource :precinct do
		desc "List all precincts"
		get do
			# list precints

			# Flintstones test message
			['Downtown-001', 'Quarrytown-002', 'QuarryCounty-003', 'County-004']
		end

		desc "List districts attached to precinct"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :list_districts do
			# list districts attached to given precinct

			# Flintstones test message
			if params[:object_id] == "Downtown-001"
				[['City of Bedrock','DISTRICT_TOWNBE'],['Cobblestone County','DISTRICT_CBLCTY']]
			elsif params[:object_id] == "Quarrytown-002"
				[['City of Bedrock','DISTRICT_TOWNBE'],['Cobblestone County','DISTRICT_CBLCTY'],['Mineral District','DISTRICT_MINERL']]
			elsif params[:object_id] == "QuarryCounty-003"
				[['Cobblestone County','DISTRICT_CBLCTY'],['Mineral District','DISTRICT_MINERL']]
			elsif params[:object_id] == "County-004"
				[['Cobblestone County','DISTRICT_CBLCTY']]
			else
				error_not_found(params[:object_id])
			end
		end

		desc "Create precinct"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:object_id])
			# create precinct

			# error if object already exists
			#error_already_exists(params[:object_id])

			# dummy message for testing
			"creating precinct"
		end

		desc "Display full info on selected precinct"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# display selected precinct info

			# error if object does not exist
			#error_not_found(params[:object_id])

			# dummy message for testing
			"precinct info"
		end

		desc "Update selected precinct"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update selected precinct

			# error if object does not exist
			#error_not_found(params[:object_id])

			# dummy message for testing
			"updated"
		end
	end

	# District methods
	resource :district do
		desc "List all districts"
		get do
			# list districts

			# Flintstones test message
			[['City of Bedrock','DISTRICT_TOWNBE'],['Cobblestone County','DISTRICT_CBLCTY'],['Mineral District','DISTRICT_MINERL']]
		end

		desc "List precincts attached to a district"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :list_precincts do
			# list precincts attached to district from jurisdiction

			if params[:object_id] == "DISTRICT_TOWNBE"
				['Downtown-001','Quarrytown-002']
			elsif params[:object_id] == "DISTRICT_CBLCTY"
				['Downtown-001','Quarrytown-002','QuarryCounty-003','County-004']
				#params[:object_id]
			elsif params[:object_id] == "DISTRICT_MINERL"
				['Quarrytown-002','QuarryCounty-003']
			else
				error_not_found(params[:object_id])
			end
		end

		desc "Create district"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:object_id])
			# create precinct and attach it to jurisdiction

			# error if object already exists
			#error_already_exists(params[:object_id])

			# dummy message for testing
			"creating district"
		end

		desc "Display district info"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# display info on the district

			# dummy message for testing
			"district info"
		end

		desc "Update district"
		params do
			# not sure if jurisdiction ID is needed
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update info for the district

			# dummy message for testing
			"updating district"
		end

		desc "Attach a precinct to a district"
		params do
			requires :object_id, type: String, allow_blank: false
			requires :precinct_id, type: String, allow_blank: false
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
			requires :jurisdiction_id, type: String, allow_blank: false
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
			validate_string_name(params[:name])
			# create a new election

			# dummy message for testing
			"creating election"
		end

		desc "Detail one election"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail selected election

			# dummy message for testing
			"election"
		end

		desc "Update one election"
		params do
			requires :object_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
		end
		post do
			# list all candidate contests

			# dummy message for testing
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end

		desc "Create candidate contest"
		params do
			requires :name, type: String
			requires :election_id, type: String, allow_blank: false
			requires :votes_allowed, type: Integer

			# vssc allows for more than one scope ID, but requires at least 1
			# not sure if this is the right way to do this
			requires :jurisdiction_scope_id, type: Array
		end
		post :create do
			validate_string_name(params[:name])
			# create the candidate contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a candidate contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the selected contest

			# dummy message for testing
			"candidate contest"
		end

		desc "Update candidate contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating candidate contest"
		end

		desc "Attach an office to contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
			requires :office_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
		end
		post do
			# list all candidates

			# dummy message for testing
			['CANDIDATE_1', 'CANDIDATE_2', 'CANDIDATE_3']
		end

		desc "Create a candidate"
		params do
			requires :object_id, type: String, allow_blank: false
			requires :election_id, type: String, allow_blank: false
			requires :ballot_name, type: String
		end
		post :create do
			validate_ocdid(params[:object_id])
			validate_string_name(params[:ballot_name])
			# create candidate

			# dummy message for testing
			"creating candidate " + params[:ballot_name]
		end

		desc "Detail a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the candidate

			# dummy message for testing
			"candidate"
		end

		desc "Update a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
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
			requires :object_id, type: String, allow_blank: false
			requires :name, type: String
		end
		post :create do
			validate_ocdid(params[:object_id])
			validate_string_name(params[:name])
			# create party

			# dummy message for testing
			"creating party " + params[:name]
		end

		desc "Detail a party"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail party

			# dummy message for testing
			"party"
		end

		desc "Update a party"
		params do
			requires :object_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
		end
		post do
			# list all candidate contests

			# dummy message for testing
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end

		desc "Create ballot measure contest"
		params do
			requires :name, type: String
			requires :election_id, type: String, allow_blank: false
			requires :ballot_measure_type, type: String

			# vssc allows for more than one scope ID, but requires at least 1
			# not sure if this is the right way to do this
			requires :jurisdiction_scope_id, type: Array
		end
		post :create do
			validate_string_name(params[:name])
			# create the ballot measure contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a ballot measure contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the selected contest

			# dummy message for testing
			"ballot measure contest"
		end

		desc "Update ballot measure contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
			requires :contest_object_id, type: String, allow_blank: false
		end
		post do
			# list selections for a contest

			# dummy message for testing
			['SELECTION_1', 'SELECTION_2']
		end

		desc "Create a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_object_id, type: String, allow_blank: false
			requires :selection, type: String
		end
		post :create do
			# create a ballot measure selection

			# dummy message for testing
			"creating selection " + params[:selection] + " in contest " + params[:object_id]
		end

		desc "Detail a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_object_id, type: String, allow_blank: false
			requires :selection_object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the selected selection

			# dummy message for testing
			"selection"
		end

		desc "Update a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_object_id, type: String, allow_blank: false
			requires :selection_object_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
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
			requires :election_id, type: String, allow_blank: false
		end
		post do
			# return all ballot styles of that election

			# dummy message for testing
			['STYLE_1', 'STYLE_2', 'STYLE_3']
		end

		desc "Create a new ballot style"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
			requires :gpunit_id, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:object_id])
			# create a new ballot style

			# dummy message for testing
			"creating new ballot style"
		end

		desc "Detail a ballot style"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the selected ballot style

			# dummy message for testing
			"ballot style"
		end

		desc "Update a ballot style"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update the selected ballot style

			# dummy message for testing
			"updating"
		end
	end

	resource :ordered_contest do
		desc "List all ordered contests"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
		end
		post do
			# list all ordered contests

			# dummy message for testing
			['CANDIDATE_1', 'CANDIDATE_2', 'CANDIDATE_3']
		end


		desc "Create an ordered contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
			requires :contest_id, type: String, allow_blank: false
		end
		post :create do
			# create an ordered contest

			# dummy message for testing
			"creating ordered contest"
		end
		desc "Detail an ordered contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the ordered contest

			# dummy message for testing
			"ordered contest"
		end
		desc "Update an ordered contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating ordered contest"
		end
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
			requires :object_id, type: String, allow_blank: false
			requires :name, type: String
		end
		post :create do
			validate_string_name(params[:name])
			# create a new office

			# dummy message for testing
			"creating new office"
		end

		desc "Detail an office"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :read do
			# detail the office

			# dummy message for testing
			"office"
		end

		desc "Update an office"
		params do
			requires :object_id, type: String, allow_blank: false
		end
		post :update do
			# update the office

			# dummy message for testing
			"updating the office"
		end
	end

end