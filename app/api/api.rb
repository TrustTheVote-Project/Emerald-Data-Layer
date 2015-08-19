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

	# OCDIDs for flintstones testing

	ocd_state_slate = "ocd-division/country:us/state:slate/"
	ocd_cobblestone_county = ocd_state_slate + "county:cobblestone/"
	ocd_bedrock = ocd_cobblestone_county + "/town:bedrock"
	ocd_mineraldistrict = ocd_cobblestone_county + "/mineral_d:1"
	ocd_Downtown001 = ocd_cobblestone_county + "/precinct:Downtown-001"
	ocd_Quarrytown002 = ocd_cobblestone_county + "/precinct:Quarrytown-002"
	ocd_QuarryCounty003 = ocd_cobblestone_county + "precinct:QuarryCounty-003"
	ocd_County004 = ocd_cobblestone_county + "precinct:County-004"
	ocd_election = "election:11-03-5000BC/" + ocd_cobblestone_county
	ocd_contest_mayor = "contest:mayor/" + ocd_cobblestone_county
	ocd_quarry_comm = "contest:quarry-commisioner/" + ocd_mineraldistrict
	ocd_referendum = "question:A/" + ocd_mineraldistrict
	ocd_candidate_fredflintstone = "candidate:fred-flintstone-1/" + ocd_contest_mayor
	ocd_candidate_bettyrubble = "candidate:bettyrubble-2/" + ocd_contest_mayor
	ocd_candidate_barneyrubble = "candidate:barneyrubble-3/" + ocd_quarry_comm
	ocd_referendum_response_yes = "response:yes/question:A/ocd-division/country:us/state:st/county:cobblestone:mineral_d:1"
	ocd_referendum_response_no = "response:no/question:A/ocd-division/country:us/state:st/county:cobblestone:mineral_d:1"
	ocd_office_mayor = "office:mayor/" + ocd_bedrock
	ocd_office_quarrycomm = "office:quarrycomm/" + ocd_cobblestone_county
	ocd_party_granite = "party:granite/" + ocd_state_slate
	ocd_party_marble = "party:marble/" + ocd_state_slate


	data_bedrock = {:name => "City of Bedrock", :ocdid => ocd_bedrock}
	data_cobblecounty = {:name => "Cobblestone County", :ocdid => ocd_cobblestone_county}
	data_mineraldistrict = {:name => "Mineral District", :ocdid => ocd_mineraldistrict}
	data_candidate_fredflintstone = {:ballot_name => "Fred Flintstone", :ocdid => ocd_candidate_fredflintstone, :contest_id => ocd_contest_mayor, :party => ocd_party_granite}
	data_candidate_bettyrubble = {:ballot_name => "Betty Rubble", :ocdid => ocd_candidate_bettyrubble, :contest_id => ocd_contest_mayor, :party => ocd_party_marble}
	data_candidate_barneyrubble = {:ballot_name => "Barney Rubble", :ocdid => ocd_candidate_barneyrubble, :contest_id => ocd_contest_mayor, :party => ocd_party_marble}
	data_referendum = {:desc => "Quarry Usage Fee", :ocdid => ocd_referendum}
	data_referendum_response_yes = {:desc => "Yes", :ocdid => ocd_referendum_response_yes}
	data_referendum_response_no = {:desc => "No", :ocdid => ocd_referendum_response_no}
	data_contest_mayor = {:desc => "Bedrock Mayor", :ocdid => ocd_contest_mayor}
	data_quarry_comm = {:desc => "Cobblestone County Commissioner", :ocdid => ocd_quarry_comm}
	data_precinct_Downtown001 = {:ocdid => ocd_Downtown001}
	data_precinct_Quarrytown002 = {:ocdid => ocd_Quarrytown002}
	data_precinct_QuarryCounty003 = {:ocdid => ocd_QuarryCounty003}
	data_precinct_County004 = {:ocdid => ocd_County004}
	data_office_mayor = {:ocdid => ocd_office_mayor}
	data_office_quarrycomm = {:ocdid => ocd_quarry_comm}
	data_party_granite = {:ocdid => data_party_granite}
	data_party_marble = {:ocdid => data_party_marble}

	helpers do


		# Error messages are defined in here
		# Messages with error() come out with the given HTTP code,
		# and have a json body of a single string:
		# {"error":"message"}

		# When a requires in a params fails, it is formatted:
		# "{"error":"object_1 is missing, object_2 is missing"


		# error message for when an object is asked for and it does not exist in the database
		def error_not_found(ocdid)
			error!('Object not found: ' + ocdid, 404)
		end

		# error message for when creating an object and the ID already exists in another object
		def error_already_exists(ocdid)
			error!('Object already exists: ' + ocdid, 409)
		end

		# error if object is empty
		# unsure about HTTP code
		def error_empty(ocdid)
			error!('Object is empty: ' + ocdid, 400)
		end

		# error if object is invalid
		def error_invalid(ocdid)
			error!('Object is invalid: ' + ocdid, 400)
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

		# validate if string is proper for a passage of text, such as
		# a description of a ballot measure
		# at this time only validates if it is printable
		def validate_string_text(string)
			if !string_printable(string)
				error_invalid_input("text", string)
			end
		end

		# validate if OCDID is formatted properly
		def validate_ocdid(ocdid)
			if !string_printable(ocdid) || !string_ocdid(ocdid)
				error_invalid_input("ocdid",ocdid)
			end
		end

		# validate if the ocdid is valid and exists
		def validate_ocdid_exists(ocdid)
			validate_ocdid(ocdid)
			if !ocdid_exists(ocdid)
				error_not_found(ocdid)
			end
		end

		# validate that ocdid does not already exist
		def validate_ocdid_duplicate(ocdid)
			validate_ocdid(ocdid)
			if ocdid_exists(ocdid)
				error_already_exists(ocdid)
			end
		end

		def validate_kml(kml)
			if !kml.original_filename.include? ".kml"
				error_invalid(kml.original_filename)
			end
		end

		# Helpers for validations

		# if string is printable (does not contain any characters that must normally be represented in escape)
		def string_printable(string)
			string.inspect == "\"" + string + "\""
		end

		# if string does not contain strange punctuation that would not work in an OCDID - only allowed punctuation is -, _, /, and :
		def string_ocdid(ocdid)
			str = ['!','"','#','$','%','(',')','*','+',',','.',';','<','=','>','?','@','[','\\',']','`','{','|','}','~']
			!str.any? { |word| ocdid.include?(word) }
		end

		# eventually will determine if ocdid already exists
		# both for use in checking if object has been created, and if it already has been created
		def ocdid_exists(ocdid)
			false
		end
	end


	# Jurisdiction methods
	resource :jurisdiction do

		desc "List jurisdictions"
		get do
			# return list of name, ID of each jurisdiction

			# error for empty list of items in database?

			# Flintstones test message
			data_cobblecounty
		end

		desc "List districts under a jurisdiction"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_districts do
			# list districts attached to given jurisdiction

			# Flintstones test message
			if params[:ocdid] == ocd_cobblestone_county
				[data_bedrock,data_cobblecounty,data_mineraldistrict]
			else
				error_not_found(params[:ocdid])
			end
		end

		desc "List all subunits of a jurisdiction, such as listing counties and districts of a state"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_subunits do
			# list all subunits

			# Flintstones test message
			if params[:ocdid] == ocd_bedrock
				[ocd_Downtown001,ocd_Quarrytown002]
			elsif params[:ocdid] == ocd_cobblestone_county
				[ocd_Downtown001,ocd_Quarrytown002,ocd_QuarryCounty003,ocd_County004]
			elsif params[:ocdid] == ocd_mineraldistrict
				[ocd_Quarrytown002,ocd_QuarryCounty003]
			else
				error_not_found(params[:ocdid])
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
			validate_ocdid(params[:ocdid])
			if params[:ocdid] == ocd_cobblestone_county
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
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# return all data from selected jurisdiction

			# error if object does not exist
			if params[:ocdid] != ocd_cobblestone_county
				error_not_found(params[:ocdid])
			end

			# dummy message for testing
			"jurisdiction data"
		end

		desc "Update selected jurisdiction"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :update do
			# update given parameters in selected jurisdiction

			# error if object does not exist
			if params[:ocdid] != ocd_cobblestone_county
				error_not_found(params[:ocdid])
			end

			# dummy message for testing
			"updating"
		end

		desc "Attach child to jurisdiction. This can be attaching a jurisdiction to another, such as
		setting a county as a child of a state. This also can be attaching a precinct or district."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :child_ocdid, type: String, allow_blank: false
		end
		post :attach do
			# attach to the given jurisdiction

			# error if object does not exist
			if params[:ocdid] != ocd_cobblestone_county
				error_not_found(params[:ocdid])
			end

			# error if child object does not exist
			if params[:child_ocdid] != ocd_bedrock && params[:child_ocdid] != ocd_cobblestone_county && params[:child_ocdid] != ocd_mineraldistrict 
				error_not_found(params[:child_ocdid])
			end

			# dummy message for testing
			"attaching"
		end

		desc "Detach a child element from a jurisdiction."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :child_id, type: String, allow_blank: false
		end
		post :detach do

			# error if object does not exist
			if params[:ocdid] != ocd_cobblestone_county
				error_not_found(params[:ocdid])
			elsif params[:child_ocdid] != ocd_bedrock && params[:child_ocdid] != ocd_cobblestone_county && params[:child_ocdid] != ocd_mineraldistrict 
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
			[ocd_Downtown001, ocd_Quarrytown002, ocd_QuarryCounty003, ocd_County004]
		end

		desc "List districts attached to precinct"
		params do
			requires :ocdid, type: String, allow_blank: false, desc: "ocdid of precinct."
		end
		post :list_districts do
			# list districts attached to given precinct

			# Flintstones test message
			if params[:ocdid] == ocd_Downtown001
				[ocd_bedrock,ocd_cobblestone_county]
			elsif params[:ocdid] == ocd_Quarrytown002
				[ocd_bedrock,ocd_cobblestone_county,ocd_mineraldistrict]
			elsif params[:ocdid] == ocd_QuarryCounty003
				[ocd_cobblestone_county,ocd_mineraldistrict]
			elsif params[:ocdid] == ocd_County004
				[ocd_cobblestone_county]
			else
				error_not_found(params[:ocdid])
			end
		end

		desc "Create precinct"
		params do
			requires :ocdid, type: String, allow_blank: false, desc: "ocdid of precinct."
			requires :spatialextent, type: Rack::Multipart::UploadedFile, allow_blank: false, desc: "Spatial definition file, kml format."
			requires :name, type: String, allow_blank: false, desc: "Name of precinct."
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_kml(params[:spatialextent])
			validate_name(params[:name])
			# create precinct

			# error if object already exists
			#error_already_exists(params[:ocdid])

			# dummy message for testing
			"creating precinct"
		end

		desc "Display full info on selected precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# display selected precinct info
			case params[:ocdid]
			when ocd_Downtown001
				data_precinct_Downtown001
			when ocd_Quarrytown002
				data_precinct_Quarrytown002
			when ocd_QuarryCounty003
				data_precinct_QuarryCounty003
			when ocd_County004
				data_precinct_County004
			else
				# error if object does not exist
				error_not_found(params[:ocdid])
			end
		end

		desc "Update selected precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :update do
			# update selected precinct

			# error if object does not exist
			#error_not_found(params[:ocdid])

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
			[ocd_bedrock,ocd_cobblestone_county,ocd_mineraldistrict]
		end

		desc "List precincts attached to a district"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_precincts do
			# list precincts attached to district from jurisdiction

			if params[:ocdid] == ocd_bedrock
				[ocd_Downtown001,ocd_Quarrytown002]
			elsif params[:ocdid] == ocd_cobblestone_county
				[ocd_Downtown001,ocd_Quarrytown002,ocd_QuarryCounty003,ocd_County004]
			elsif params[:ocdid] == ocd_mineraldistrict
				[ocd_Quarrytown002,ocd_QuarryCounty003]
			else
				error_not_found(params[:ocdid])
			end
		end

		desc "Create district"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :spatialextent, type: Rack::Multipart::UploadedFile, allow_blank: false, desc: "Spatial definition file, kml format."
			requires :name, type: String, allow_blank: false, desc: "Name of precinct."
			# district subtype?
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_kml(params[:spatialextent])
			validate_name(params[:name])
			# create precinct and attach it to jurisdiction

			# error if object already exists
			#error_already_exists(params[:ocdid])

			# dummy message for testing
			"creating district"
		end

		desc "Display district info"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# display info on the district

			# dummy message for testing
			"district info"
		end

		desc "Update district"
		params do
			# not sure if jurisdiction ID is needed
			requires :ocdid, type: String, allow_blank: false
		end
		post :update do
			# update info for the district

			# dummy message for testing
			"updating district"
		end

		desc "Attach a precinct to a district"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :precinct_id, type: String, allow_blank: false
		end
		post :attach_precinct do
			# attach precinct to district

			# dummy message for testing
			"attaching precinct " + params[:precinct_id] + " to district " + params[:ocdid]
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
			requires :election_type, type: Integer
			requires :name, type: String, allow_blank: false
			requires :scope_id, type: String, allow_blank: false
		end
		post :create do
			validate_string_name(params[:name])
			validate_ocdid_exists(params[:scope_id])
			# create a new election

			# dummy message for testing
			"creating election"
		end

		desc "Detail one election"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail selected election

			# dummy message for testing
			"election"
		end

		desc "Update one election"
		params do
			requires :ocdid, type: String, allow_blank: false
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
			if params[:election_id] == ocd_election
				[ocd_contest_mayor,ocd_quarry_comm]
			else
				error_invalid(params[:election_id])
			end
		end

		desc "Create candidate contest"
		params do
			requires :name, type: String, allow_blank: false, desc: "Name of contest, e.g. \"Governor.\""
			requires :election_id, type: String, allow_blank: false, desc: "ocdid of election the contest is under."
			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String, allow_blank: false
			requires :ballot_subtitle, type: String, allow_blank: false
			requires :vote_variation_type, type: Integer # integer as position in enum in schema
		end
		post :create do
			validate_string_name(params[:name])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])
			# validate vote variation type

			# create the candidate contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a candidate contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			if params[:election_id] == ocd_election
				if params[:ocdid] == ocd_contest_mayor
					data_contest_mayor
				elsif params[:ocdid] == ocd_quarry_comm
					data_quarry_comm
				else
					error_invalid(params[:ocdid])
				end
			else
				error_invalid(params[:election_id])
			end
		end

		desc "Update candidate contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :update do
			# update the selected contest

			# dummy message for testing
			"updating candidate contest"
		end

		desc "Attach an office to contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
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
			if params[:election_id] == ocd_election
				[ocd_candidate_fredflintstone, ocd_candidate_bettyrubble, ocd_candidate_barneyrubble]
			else
				# dummy message for testing
				['CANDIDATE_1', 'CANDIDATE_2', 'CANDIDATE_3']
			end
		end

		desc "Create a candidate"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :election_id, type: String, allow_blank: false
			requires :ballot_name, type: String, allow_blank: false
			requires :party_id, type: String, allow_blank: false, desc: "ocdid of affiliated party."

			# 'person' subclass here
			requires :first_name, type: String, allow_blank: false
			requires :middle_name, type: String
			requires :last_name, type: String, allow_blank: false
			requires :prefix, type: String
			requires :suffix, type: String
			requires :profession, type: String, allow_blank: false

		end
		post :create do
			validate_ocdid_duplicate(params[:ocdid])
			validate_string_name(params[:ballot_name])
			validate_string_name(params[:first_name])
			validate_string_name(params[:middle_name])
			validate_string_name(params[:last_name])
			validate_string_name(params[:prefix])
			validate_string_name(params[:suffix])
			validate_string_name(params[:profession])

			# validate that election, party IDs exist
			validate_ocdid_exists(params[:election_id])
			validate_ocdid_exists(params[:party_id])

			# create candidate

			# dummy message for testing
			"creating candidate " + params[:ballot_name]
		end

		desc "Detail a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail the candidate
			if params[:election_id] == ocd_election
				case params[:ocdid]
				when ocd_candidate_fredflintstone
					data_candidate_fredflintstone
				when ocd_candidate_bettyrubble
					data_candidate_bettyrubble
				when ocd_candidate_barneyrubble
					data_candidate_barneyrubble
				else
					error_invalid(params[:ocdid])
				end	
			else
				"candidate"
			end

			# dummy message for testing
		end

		desc "Update a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
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
			[ocd_party_marble, ocd_party_granite]
		end

		desc "Create a new party"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String, allow_blank: false
			requires :color, type: Integer, desc: "HTML color of party."
			requires :abbreviation, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])
			# create party

			# dummy message for testing
			"creating party " + params[:name]
		end

		desc "Detail a party"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail party

			# dummy message for testing
			if params[:ocdid] == ocd_party_marble
				data_party_marble
			elsif params[:ocdid] == ocd_party_granite
				data_party_granite
			else
				error_not_found(params[:ocdid])
			end
		end

		desc "Update a party"
		params do
			requires :ocdid, type: String, allow_blank: false
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
			# list all ballot measure contests
			if params[:election_id] == ocd_election
				[ocd_referendum]
			else
				# dummy message for testing
				['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
			end
		end

		desc "Create ballot measure contest"
		params do
			requires :name, type: String, allow_blank: false, desc: "Name of contest, e.g. \"Governor.\""
			requires :election_id, type: String, allow_blank: false, desc: "ocdid of election the contest is under."
			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String, allow_blank: false
			requires :ballot_subtitle, type: String, allow_blank: false
			requires :ballot_measure_type, type: Integer # integer as position in enum in schema

			requires :pro_statement, type: String, allow_blank: false
			requires :con_statement, type: String, allow_blank: false
			requires :passage_threshold, type: String, allow_blank: false
			requires :full_text, type: String, allow_blank: false
			requires :summary_text, type: String, allow_blank: false
			requires :effect_of_abstain, type: String, allow_blank: false
		end
		post :create do
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])

			validate_string_text(params[:pro_statement])
			validate_string_text(params[:con_statement])
			validate_string_text(params[:passage_threshold]) # best way to validate?a
			validate_string_text(params[:full_text])
			validate_string_text(params[:summary_text])
			validate_string_text(params[:effect_of_abstain])
			# create the ballot measure contest

			# dummy message for testing
			"creating contest " + params[:name]
		end

		desc "List detail of a ballot measure contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail the selected contest
			if params[:election_id] = ocd_election
				if params[:ocdid] == ocd_referendum
					data_referendum
				else
					error_invalid(params[:ocdid])
				end
			else
				error_invalid(params[:election_id])
			end
		end

		desc "Update ballot measure contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
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
			requires :contest_ocdid, type: String, allow_blank: false
		end
		post do
			# list selections for a contest
			if params[:election_id] == ocd_election
				if params[:contest_ocdid] == ocd_referendum
					[ocd_referendum_response_yes,ocd_referendum_response_no]
				else
					error_invalid(params[:contest_ocdid])
				end
			else
				error_invalid(params[:election_id])
			end
		end

		desc "Create a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :selection, type: String
		end
		post :create do
			# create a ballot measure selection
			validate_ocdid_duplicate(params[:ocdid])

			# dummy message for testing
			"creating selection " + params[:selection] + " in contest " + params[:ocdid]
		end

		desc "Detail a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
			requires :selection_ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail the selected selection
			if params[:election_id] == ocd_election
				if params[:contest_ocdid] == ocd_referendum
					if params[:selection_ocdid] == ocd_referendum_response_yes
						data_referendum_response_yes
					elsif params[:selection_ocdid] == ocd_referendum_response_no
						data_referendum_response_no
					else
						error_invalid(params[:selection_ocdid])
					end
				else
					error_invalid(params[:contest_ocdid])
				end
			else
				error_invalid(params[:election_id])
			end
		end

		desc "Update a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
			requires :selection_ocdid, type: String, allow_blank: false
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
			if params[:election_id] == ocd_election
				[ocd_contest_mayor,ocd_quarry_comm,ocd_referendum]
			else
				error_invalid(params[:election_id])
			end
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
			requires :ocdid, type: String, allow_blank: false
			requires :gpunit_id, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid_duplicate(params[:ocdid])
			# create a new ballot style

			# dummy message for testing
			"creating new ballot style"
		end

		desc "Detail a ballot style"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail the selected ballot style

			# dummy message for testing
			"ballot style"
		end

		desc "Update a ballot style"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
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
			['CONTEST_1', 'CONTEST_2', 'CONTEST_3']
		end


		desc "Create an ordered contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :contest_id, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid_duplicate(params[:ocdid])
			validate_ocdid_exists(params[:election_id])
			validate_ocdid_exists(params[:ballot_style_id])
			validate_ocdid_exists(params[:contest_id])
			# create an ordered contest

			# dummy message for testing
			"creating ordered contest"
		end
		desc "Detail an ordered contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ballot_style_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
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
			requires :ocdid, type: String, allow_blank: false
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
			[ocd_office_mayor, ocd_office_quarrycomm]
		end

		desc "Create a new office"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String, allow_blank: false
		end
		post :create do
			validate_string_name(params[:name])
			validate_ocdid_duplicate(params[:ocdid])
			# create a new office

			# dummy message for testing
			"creating new office"
		end

		desc "Detail an office"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			# detail the office
			if params[:ocdid] == ocd_office_mayor
				data_office_mayor
			elsif params[:ocdid] == ocd_office_quarrycomm
				data_office_quarrycomm
			else
				error_not_found(params[:ocdid])
			end
		end

		desc "Update an office"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :update do
			# update the office

			# dummy message for testing
			"updating the office"
		end
	end

end