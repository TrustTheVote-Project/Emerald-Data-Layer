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
	# If just get do, then .../api/v1/hello


	# Jurisdiction methods
	resource :jurisdiction do

		desc "List jurisdiction data"
		get do
			# return list of name, ID of each jurisdiction

			# dummy message for testing
			"OK"
		end

		desc "Create new jurisdiction, manually inputting parameters."
		params do
			requires :name, type: String
		end
		post :create do
			# create jurisdiction
			# params allowed are those defined in VSSC for ReportingUnit

			# dummy message for testing
			"creating jurisdiction " + params[:name]
		end

		desc "Import jurisdiction"
		params do
			# only the data string
			requires :info, type: String
		end
		post :import do
			# parse and create jurisdiction
		end

		desc "Add contact info to selected jurisdiction"
		params do
			# No strings in contact info are 'required,' only assert jurisdiction
			# id to be modified
			requires :jurisdiction_id, type: String
		end
		post :update_contact_info do
			# add contact info to jurisdiction

			# dummy message for testing
			"updating"
		end
	end

	# Precinct methods

	resource :precinct do
		desc "List precincts of a selected jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
		end
		post do
			# list precints attached to given jurisdiction

			# dummy message for testing
			['PRECINCT_1', 'PRECINCT_2', 'PRECINCT_3']
		end

		desc "Create precinct, attached to a jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
			requires :name, type: String
		end
		post :create do
			# create precinct and attach it to jurisdiction

			# dummy message for testing
			"creating precinct " + params[:name] + " attached to " + params[:parent_jurisdiction_id]
		end

	end

	# District methods


	resource :district do

		desc "List districts of a selected jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
		end
		post do
			# list districts attached to given jurisdiction

			# dummy message for testing
			['DISTRICT_1', 'DISTRICT_2', 'DISTRICT_3']
		end

		desc "Create district, attached to a jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
			requires :name, type: String
		end
		post :create do
			# create precinct and attach it to jurisdiction

			# dummy message for testing
			"creating precinct " + params[:name] + " attached to " + params[:parent_jurisdiction_id]
		end

		desc "List precincts attached to a district from a jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
			requires :district_id, type: String
		end
		post :list_precincts do
			# create precinct and attach it to jurisdiction

			# dummy message for testing
			['PRECINCT_1', 'PRECINCT_2', 'PRECINCT_3']
		end

		desc "Attach a precinct to a district from a jurisdiction"
		params do
			requires :parent_jurisdiction_id, type: String
			requires :district_id, type: String
			requires :precinct_id, type: String
		end
		post :attach_precinct do
			# attach precinct to district

			# dummy message for testing
			"attaching precinct " + params[:precinct_id] + " to district " + params[:district_id]
		end

	end

end