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

	ocd_state_slate = "ocd-division/country:us/state:slate"
	ocd_cobblestone_county = ocd_state_slate + "/county:cobblestone"
	ocd_bedrock = ocd_cobblestone_county + "/town:bedrock"
	ocd_mineraldistrict = ocd_cobblestone_county + "/mineral_d:1"
	ocd_Downtown001 = ocd_cobblestone_county + "/precinct:Downtown-001"
	ocd_Quarrytown002 = ocd_cobblestone_county + "/precinct:Quarrytown-002"
	ocd_QuarryCounty003 = ocd_cobblestone_county + "/precinct:QuarryCounty-003"
	ocd_County004 = ocd_cobblestone_county + "/precinct:County-004"
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
	data_cobblecounty = {:name => "Cobblestone County", :ocdid => ocd_cobblestone_county, :elorg_name => "Cobblestone County"}
	data_mineraldistrict = {:name => "Mineral District", :ocdid => ocd_mineraldistrict}
	data_candidate_fredflintstone = {:ballot_name => "Fred Flintstone", :ocdid => ocd_candidate_fredflintstone, :contest_id => ocd_contest_mayor, :party => ocd_party_granite}
	data_candidate_bettyrubble = {:ballot_name => "Betty Rubble", :ocdid => ocd_candidate_bettyrubble, :contest_id => ocd_contest_mayor, :party => ocd_party_marble}
	data_candidate_barneyrubble = {:ballot_name => "Barney Rubble", :ocdid => ocd_candidate_barneyrubble, :contest_id => ocd_contest_mayor, :party => ocd_party_marble}
	data_referendum = {:desc => "Quarry Usage Fee", :ocdid => ocd_referendum}
	data_referendum_response_yes = {:desc => "Yes", :ocdid => ocd_referendum_response_yes}
	data_referendum_response_no = {:desc => "No", :ocdid => ocd_referendum_response_no}
	data_contest_mayor = {:desc => "Bedrock Mayor", :ocdid => ocd_contest_mayor}
	data_quarry_comm = {:desc => "Cobblestone County Commissioner", :ocdid => ocd_quarry_comm}
	data_precinct_Downtown001 = {:ocdid => ocd_Downtown001, :name => "Downtown001"}
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

		# error if ocdid given is not the correct type of object
		def error_wrong_type(type, value)
			error!(value + ' is not a : ' + type, 400)
		end

		# error if enum position integer is out of the range of possible options
		def error_enum_range(type, value)
			error!(value.to_s + ' is out of the range of ' + type, 400)
		end

		def error_already_attached(parent, child)
			error!(child + ' is already attached to ' + parent, 400)
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

		# placeholder for validation if OCDID is correct type
		# not quite sure how it should be called and checked at this point
		def validate_ocdid_type(ocdid, type)
			true
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
			if !kml[:filename].include? ".kml"
				error_invalid(kml[:filename])
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

		def get_enum_by_index(enum, index, descstring)
			ret = enum.enums[(2 * index) + 1]
			if ret
				ret
			else
				error_enum_range(descstring, index)
			end
		end
	end


	# Jurisdiction methods
	resource :jurisdictions do

		desc "List jurisdictions"
		get do
			# return list of all jurisdictions
			j = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("national").to_s)
			j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("state").to_s)
			j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("county").to_s)

			j.collect do |p|
				{
					id: p.id,
					ocdid: p.object_id
				}
			end
		end

		desc "List districts under a jurisdiction"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_districts do
			validate_ocdid(params[:ocdid])
			j = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("national").to_s)
			j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("state").to_s)
			j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("county").to_s)

      		u = j.find_by_object_id(params[:ocdid])
			if u
				status 200
				return u.composing_gp_units.where(is_electoral_district: true).collect do |p|
					{
						id: p.id,
						ocdid: p.object_id
					}
				end
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "List all subunits of a jurisdiction, such as listing counties and districts of a state"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_subunits do
			validate_ocdid(params[:ocdid])

			#j = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("national").to_s)
			#j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("state").to_s)
			#j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("county").to_s)

      		#u = j.find_by_object_id(params[:ocdid])

      		u = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])

			if u
				status 200
				return u.composing_gp_units.collect do |p|
					{
						id: p.id,
						ocdid: p.object_id
					}
				end
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Create new jurisdiction, manually inputting parameters."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String
			#requires :elorg_name, type: String
			requires :unit_type, type: Integer, desc: "Enum index of reporting unit type"
		end
		post :create do
			validate_string_name(params[:name])
			#validate_string_name(params[:elorg_name])
			validate_ocdid(params[:ocdid])
			if Vssc::ReportingUnit.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			j = Vssc::ReportingUnit.new(object_id: params[:ocdid], name: params[:name], 
				reporting_unit_type: get_enum_by_index(Vssc::Enum::ReportingUnitType, params[:unit_type], "jurisdiction"))
			
			if j.save
				status 200
				return j
			else
				status 500
				return j.errors
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
			validate_ocdid(params[:ocdid])

			#j = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("national").to_s)
			#j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("state").to_s)
			#j += Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("county").to_s)

      		p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			if p
				status 200
				return p
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update selected jurisdiction"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String
			#requires :elorg_name, type: String
		end
		post :update do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:name])
			#validate_string_name(params[:elorg_name])

			attributes = params.dup
			j = Vssc::ReportingUnit.find_by_object_id(attributes.delete(:ocdid))
			if j.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected jurisdiction
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				j.name = attributes[:name]
				if j.save
					status 200
					return j
				else
					status 500
					return j.errors
				end
			end
		end

		desc "Attach child to jurisdiction. This can be attaching a jurisdiction to another, such as
		setting a county as a child of a state. This also can be attaching a precinct or district."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :child_ocdid, type: String, allow_blank: false
		end
		post :attach do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:child_ocdid])

			p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:ocdid])
			end

			c = Vssc::ReportingUnit.find_by_object_id(params[:child_ocdid])
			if c.nil?
				status 400
				error_not_found(params[:child_ocdid])
			end

			if p.composing_gp_units.where(object_id: params[:child_ocdid]).count > 0
				error_already_attached(params[:ocdid], params[:child_ocdid])
			end

			# attach precinct to precinct
			p.composing_gp_units << c
			if p.save
				status 200
				return p.to_json(include: :composing_gp_units)
			else
				status 500
				return p.errors
			end
		end

		desc "Detach a child element from a jurisdiction."
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :child_ocdid, type: String, allow_blank: false
		end
		post :detach do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:child_ocdid])

			p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:ocdid])
			end

			c = p.composing_gp_units.find_by_object_id(params[:child_ocdid])
			if c.nil?
				status 400
				error_not_found(params[:child_ocdid])
			end

			# delete only association
			p.composing_gp_units.delete(c)

			if p.save
				status 200
				return p.to_json(include: :composing_gp_units)
			else
				status 500
				return p.errors
			end
		end
	end

	# Precinct methods
	resources :precincts do
		desc "List all precincts"
		get do
			# list precints
			return Vssc::ReportingUnit.limit(10).where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).collect do |p|
				{
					id: p.id,
					ocdid: p.object_id
				}
			end
		end

		desc "List districts with selected precinct as a child"
		params do
			requires :ocdid, type: String, allow_blank: false, desc: "ocdid of precinct."
		end
		post :list_districts do
			validate_ocdid(params[:ocdid])

			# Find all districts
			d = Vssc::ReportingUnit.where(is_electoral_district: true)

			# Create dummy reportingunit to store each correct district in
			b = Vssc::ReportingUnit.new()

			# For each district, if its composing gpunits includes the precinct, add it to dummy
			d.collect do |a|
				a.composing_gp_units.collect do |c|
					if c.object_id == params[:ocdid]
						b.composing_gp_units << a
					end
				end
			end

			# return list of all found districts
			return b.composing_gp_units.collect do |r|
				{
					id: r.id,
					ocdid: r.object_id
				}
			end
		end
    
	    desc "List composing units of a precinct"
		params do
			requires :ocdid, type: String, allow_blank: false, desc: "ocdid of precinct."
		end
		post :list_composing_precincts do
			validate_ocdid(params[:ocdid])
			p = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).find_by_object_id(params[:ocdid])
			if p
				status 200
				return p.composing_gp_units.collect do |p|
					{
						id: p.id,
						ocdid: p.object_id
					}
				end
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end
    

		desc "Create precinct"
		params do
			requires :ocdid, type: String, allow_blank: false, desc: "ocdid of precinct."
			requires :spatialextent, allow_blank: false, desc: "Spatial definition file, kml format."
			requires :name, type: String, allow_blank: false, desc: "Name of precinct."
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_kml(params[:spatialextent])
			validate_string_name(params[:name])

			# error if object already exists			
			if Vssc::ReportingUnit.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			p = Vssc::ReportingUnit.new(object_id: params[:ocdid], name: params[:name], reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct"))

			if p.save
				status 200
				return p
			else
				status 500
				return p.errors
			end
		end

		desc "Display full info on selected precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
      		#p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			p = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).find_by_object_id(params[:ocdid])
			if p
				status 200
				return p
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update selected precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
			#requires :spatialextent, allow_blank: true, desc: "Spatial definition file, kml format."
			optional :name, type: String, desc: "Name of precinct."
		end
		post :update do
			validate_ocdid(params[:ocdid])
			if params[:spatialextent] != "" && params[:spatialextent] 
				validate_kml(params[:spatialextent])
			end			
			validate_string_name(params[:name])
			
			# error if object does not exist
			attributes = params.dup
			p = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).find_by_object_id(attributes.delete(:ocdid))
			if p.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected precinct
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				p.name = attributes[:name]
				if p.save
					status 200
					return p
				else
					status 500
					return p.errors
				end
			end
		end

		desc "Attach a precinct to a precinct, in the case of a split precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :composing_ocdid, type: String, allow_blank: false
		end
		post :attach_precinct do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:composing_ocdid])

			p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:ocdid])
			end

			composing_p = Vssc::ReportingUnit.find_by_object_id(params[:composing_ocdid])
			if composing_p.nil?
				status 400
				error_not_found(params[:composing_ocdid])
			end

			if p.composing_gp_units.where(object_id: params[:composing_ocdid]).count > 0
				error_already_attached(params[:ocdid], params[:composing_ocdid])
			end

			# attach precinct to precinct
			p.composing_gp_units << composing_p
			if p.save
				status 200
				return p.to_json(include: :composing_gp_units)
			else
				status 500
				return p.errors
			end
		end

		desc "Detach a precinct from a precinct, in the case of a split precinct"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :composing_ocdid, type: String, allow_blank: false
		end
		post :detach_precinct do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:composing_ocdid])

			p = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:ocdid])
			end

			composing_p = p.composing_gp_units.find_by_object_id(params[:composing_ocdid])
			if composing_p.nil?
				status 400
				error_not_found(params[:composing_ocdid])
			end

			# only delete association
			p.composing_gp_units.delete(composing_p)

			if p.save
				status 200
				return p.to_json(include: :composing_gp_units)
			else
				status 500
				return p.errors
			end
		end


		desc "Get spatial extent."
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :spatialextent do
			validate_ocdid(params[:ocdid])

			status 200
			"kml data"
		end
	end

	# District methods
	resource :districts do
		desc "List all districts"
		get do
			# list electoral districts
			return Vssc::ReportingUnit.limit(10).where(is_electoral_district: true).collect do |d|
				{
					id: d.id,
					ocdid: d.object_id
				}
			end
		end

		desc "List precincts attached to a district"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :list_precincts do
			validate_ocdid(params[:ocdid])
			# list precincts attached to district from jurisdiction

      		d = Vssc::ReportingUnit.where(is_electoral_district: true).find_by_object_id(params[:ocdid])
			if d
				status 200
				return d.composing_gp_units.collect do |p|
					{
						id: p.id,
						ocdid: p.object_id
					}
				end
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Create district"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :spatialextent, allow_blank: false, desc: "Spatial definition file, kml format."
			requires :name, type: String, allow_blank: false, desc: "Name of precinct."
			# district subtype?
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_kml(params[:spatialextent])
			validate_string_name(params[:name])

			if Vssc::ReportingUnit.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			d = Vssc::ReportingUnit.new(object_id: params[:ocdid], name: params[:name], is_electoral_district: true)
			
			if d.save
				status 200
				return d
			else
				status 500
				return d.errors
			end
		end

		desc "Display district info"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
			# display info on the district

  			#d = Vssc::ReportingUnit.find_by_object_id(params[:ocdid])
      		d = Vssc::ReportingUnit.where(is_electoral_district: true).find_by_object_id(params[:ocdid])
			if d
				status 200
				return d
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update district"
		params do
			# not sure if jurisdiction ID is needed
			requires :ocdid, type: String, allow_blank: false
			#requires :spatialextent, allow_blank: false, desc: "Spatial definition file, kml format."
			requires :name, type: String, desc: "Name of precinct."
		end
		post :update do
			validate_ocdid(params[:ocdid])
			if params[:spatialextent] != "" && params[:spatialextent] 
				validate_kml(params[:spatialextent])
			end			
			validate_string_name(params[:name])
			
			# error if object does not exist
			attributes = params.dup
			p = Vssc::ReportingUnit.where(is_electoral_district: true).find_by_object_id(attributes.delete(:ocdid))
			if p.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected precinct
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				p.name = attributes[:name]
				if p.save
					status 200
					return p
				else
					status 500
					return p.errors
				end
			end
		end

		desc "Attach a precinct to a district"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :precinct_ocdid, type: String, allow_blank: false
		end
		post :attach_precinct do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:precinct_ocdid])

			# confirm OCDID exists and is a district
			d = Vssc::ReportingUnit.where(is_electoral_district: true).find_by_object_id(params[:ocdid])
			if d.nil?
				status 400
				error_not_found(params[:ocdid])
			end

			# confirm precinct OCDID exists and is a precinct
			p = Vssc::ReportingUnit.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).find_by_object_id(params[:precinct_ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:precinct_ocdid])
			end

			# make sure precinct is not already attached
			if d.composing_gp_units.where(object_id: params[:precinct_ocdid]).count > 0
				error_already_attached(params[:ocdid], params[:precinct_ocdid])
			end

			# attach precinct to precinct
			d.composing_gp_units << p
			if d.save
				status 200
				return d.to_json(include: :composing_gp_units)
			else
				status 500
				return d.errors
			end
		end

		# How?
		desc "Detach a precinct from a district"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :precinct_ocdid, type: String, allow_blank: false
		end
		post :detach_precinct do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:precinct_ocdid])

			# confirm OCDID exists and is a district
			d = Vssc::ReportingUnit.where(is_electoral_district: true).find_by_object_id(params[:ocdid])
			if d.nil?
				status 400
				error_not_found(params[:ocdid])
			end

			# confirm precinct OCDID exists in district's subunits and is a precinct
			p = d.composing_gp_units.where(reporting_unit_type: Vssc::Enum::ReportingUnitType.find("precinct").to_s).find_by_object_id(params[:precinct_ocdid])
			if p.nil?
				status 400
				return error_not_found(params[:precinct_ocdid])
			end

			# only delete association
			d.composing_gp_units.delete(p)

			if d.save
				status 200
				return d.to_json(include: :composing_gp_units)
			else
				status 500
				return d.errors
			end
		end

		desc "Get spatial extent."
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :spatialextent do
			validate_ocdid(params[:ocdid])

			status 200
			"kml data"
		end
	end

	resource :elections do
		desc "List all elections"
		get do
			return Vssc::Election.limit(10).collect do |e|
				{
					id: e.id,
					name: e.name
				}
			end
		end

		desc "List all elections under a certain scope"
		params do
			requires :jurisdiction_ocdid, type: String, allow_blank: false
		end
		post do
			validate_ocdid(params[:jurisdiction_ocdid])
			# list elections under given jurisdiction
			j = Vssc::GpUnit.find_by_object_id(params[:jurisdiction_ocdid])
			if j.nil?
				status 400
				return error_not_found(params[:jurisdiction_ocdid])
			end
			status 200
			return Vssc::Election.where(election_scope_identifier: params[:jurisdiction_ocdid]).collect do |e|
				{
					id: e.id,
					name: e.name
				}
			end
		end

		desc "Create new election"
		params do
			requires :date_month, type: Integer
			requires :date_day, type: Integer
			requires :date_year, type: Integer
			requires :election_type, type: Integer
			requires :name, type: String, allow_blank: false
			requires :scope_ocdid, type: String, allow_blank: false
		end
		post :create do
			validate_string_name(params[:name])
			# create a new election

			# validate whether scope OCDID is proper
			s = Vssc::GpUnit.find_by_object_id(params[:scope_ocdid])
			if s.nil?
				status 400
				return error_not_found(params[:scope_ocdid])
			end

			# Language for internationalized name?
			name = Vssc::InternationalizedText.new()
			name.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:name])

			# Asks for countstatus for some reason?
			e = Vssc::Election.new(election_scope_identifier: params[:scope_ocdid], name: name, 
				election_type: get_enum_by_index(Vssc::Enum::ElectionType, params[:election_type], "electiontype"),
				date: Date.new(params[:date_year], params[:date_month], params[:date_day]),
				end_date: Date.new(params[:date_year], params[:date_month], params[:date_day]))

			if e.save
				status 200
				return e
			else
				status 500
				return e.errors
			end
		end

		desc "Detail one election"
		params do
			requires :id, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
			e = Vssc::Election.find_by_object_id(params[:id])
			if e
				status 200
				return e
			else
				# error if object does not exist
				status 404
				error_not_found(params[:id])
			end
		end

		desc "Update one election"
		params do
			requires :id, type: String, allow_blank: false
			requires :date_month, type: Integer
			requires :date_day, type: Integer
			requires :date_year, type: Integer
			requires :election_type, type: Integer
			requires :name, type: String, allow_blank: false
		end
		post :update do
			validate_string_name(params[:name])
			
			# error if object does not exist
			attributes = params.dup
			e = Vssc::Election.where(id: params[:id])
			#return e
			if e.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected precinct
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				#e.name = attributes[:name]
				if params[:election_type]
					#e.election_type = get_enum_by_index(Vssc::Enum::ElectionType, params[:election_type], "ElectionType")
					"hello"
				end
				if e.save
					status 200
					return e
				else
					status 500
					return e.errors
				end
			end
		end
	end

	resource :candidate_contests do
		desc "List all candidate contests under an election"
		params do
			requires :election_id, type: String, allow_blank: false
		end
		post do
			status 200
			return Vssc::CandidateContest.limit(10).collect do |cc|
				{
					id: cc.id,
					ocdid: cc.object_id
				}
			end
		end

		desc "Create candidate contest"
		params do
			requires :name, type: String, allow_blank: false, desc: "Name of contest, e.g. \"Governor.\""
			requires :ocdid, type: String, allow_blank: false, desc: "OCDID of contest being created"
			requires :election_id, type: String, allow_blank: false, desc: "id of election the contest is under."
			requires :scope_ocdid, type: String, allow_blank: false, desc: "OCDID of jurisdiction scope"
			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String, allow_blank: false
			requires :ballot_subtitle, type: String, allow_blank: false
			requires :vote_variation_type, type: Integer, desc: "Integer as position in enum in schema"
			requires :sequence_order, type: Integer, allow_blank: false
		end
		post :create do
			validate_string_name(params[:name])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:scope_ocdid])

			# error if object already exists			
			if Vssc::CandidateContest.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			# verify scope ocdid exists
			s = Vssc::ReportingUnit.find_by_object_id(params[:scope_ocdid])
			if s.nil?
				status 400
				error_not_found(params[:scope_ocdid])
			end

			title = Vssc::InternationalizedText.new()
			title.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:ballot_title])
			subtitle = Vssc::InternationalizedText.new()
			subtitle.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:ballot_subtitle])

			# ballot title and ballot sub title should not be ID fields
			cc = Vssc::CandidateContest.new(object_id: params[:ocdid], name: params[:name], abbreviation: params[:abbreviation], 
				ballot_title_id: title, ballot_sub_title_id: subtitle, sequence_order: params[:sequence_order], jurisdictional_scope_identifier: params[:scope_ocdid], 
				vote_variation_type: get_enum_by_index(Vssc::Enum::VoteVariationType, params[:vote_variation_type], "votevariationtype"))

			if cc.save
				status 200
				return cc
			else
				status 500
				return cc.errors
			end
		end

		desc "List detail of a candidate contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:election_id])

			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate contest
			#cc = e.contests.find_by_object_id(params[:ocdid])

			# temporary until elections work
			cc = Vssc::CandidateContest.find_by_object_id(params[:ocdid])
			if cc
				status 200
				return cc
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update candidate contest"
		params do
			requires :election_ocdid, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String
			requires :ballot_subtitle, type: String
			requires :vote_variation_type, type: Integer, desc: "Integer as position in enum in schema"
			requires :sequence_order, type: Integer
		end
		post :update do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:election_ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])
			# update the selected contest
			status 200

			# dummy message for testing
			"updating candidate contest"
		end

		desc "Attach an office to contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :office_ocdid, type: String, allow_blank: false
		end
		post :attach_office do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:office_ocdid])

			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate contest
			#cc = e.contests.find_by_object_id(params[:ocdid])

			# temporary until elections work
			cc = Vssc::CandidateContest.find_by_object_id(params[:ocdid])
			if cc.nil?
				status 400
				error_not_found(params[:ocdid])
			end

			o = Vssc::Office.find_by_object_id(params[:office_ocdid])
			if o.nil?
				status 400
				error_not_found(params[:office_ocdid])
			end

			# make sure connection does not already exist
			if cc.contest_office_id_refs.where(office_id_ref: params[:office_ocdid]).where(contest_id: cc.id).size > 0
				error_already_attached(params[:ocdid], params[:office_ocdid])
			end

			cor = Vssc::ContestOfficeIdRef.new(office_id_ref: params[:office_ocdid])

			cc.contest_office_id_refs << cor

			if cor.save
				if cc.save
					status 201
					return cor
				else
					status 500
					return cc.errors
				end
			else
				status 500
				return cor.errors
			end
		end

		desc "Detach an office from contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :office_ocdid, type: String, allow_blank: false
		end
		post :detach_office do
			validate_ocdid(params[:election_id])
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:office_ocdid])

			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate contest
			#cc = e.contests.find_by_object_id(params[:ocdid])

			# temporary until elections work
			cc = Vssc::CandidateContest.find_by_object_id(params[:ocdid])
			if cc.nil?
				status 400
				error_not_found(params[:ocdid])
			end

			o = Vssc::Office.find_by_object_id(params[:office_ocdid])
			if o.nil?
				status 400
				error_not_found(params[:office_ocdid])
			end

			cor = cc.contest_office_id_refs.where(office_id_ref: params[:office_ocdid]).first
			if cor.nil?
				status 400
				error_not_found(params[:office_ocdid])
			end

			cc.contest_office_id_refs.delete(cor)
			
			if cc.save
				status 200
				return cc
			else
				status 500
				return cc.errors
			end
		end
	end

	resource :candidates do
		desc "List all candidates in an election"
		params do
			requires :election_id, type: String, allow_blank: false
		end
		post do
			# list all candidates in selected object
			e = Vssc::Election.where(id: params[:election_id]).first
			if e
				status 200
				return e.candidates.collect do |c|
					{
						object_id: c.object_id,
						name: c.ballot_name.language_strings.where(language: "en-US").first.text
					}
				end
			else
				# error if object does not exist
				status 404
				error_not_found(params[:id])
			end
		end

		desc "Create a candidate"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :election_id, type: String, allow_blank: false
			requires :ballot_name, type: String, allow_blank: false
			requires :party_ocdid, type: String, allow_blank: false, desc: "ocdid of affiliated party."

			# 'person' subclass here
			requires :first_name, type: String, allow_blank: false
			requires :middle_name, type: String
			requires :last_name, type: String, allow_blank: false
			requires :prefix, type: String
			requires :suffix, type: String
			requires :profession, type: String, allow_blank: false

		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:ballot_name])
			validate_string_name(params[:first_name])
			validate_string_name(params[:middle_name])
			validate_string_name(params[:last_name])
			validate_string_name(params[:prefix])
			validate_string_name(params[:suffix])
			validate_string_name(params[:profession])


			# error if object already exists			
			if Vssc::Candidate.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			# validate that election, party IDs exist
			p = Vssc::Party.find_by_object_id(params[:party_ocdid])
			if p.nil?
				status 400
				error_not_found(params[:party_ocdid])
			end

			ballotname = Vssc::InternationalizedText.new()
			ballotname.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:name])

			profession = Vssc::InternationalizedText.new()
			profession.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:profession])

			p = Vssc::Person.new(object_id: params[:ocdid], first_name: params[:first_name], middle_names: [params[:middle_name]], 
				last_name: params[:last_name], prefix: params[:prefix], sufix: params[:suffix], profession: profession, full_name: ballotname)

			if p.save
				c = Vssc::Candidate.new(object_id: params[:ocdid], ballot_name: ballotname, person_identifier: p.id, party_identifier: params[:party_ocdid])
				if c.save
					status 200
					return [c,p]
				else
					status 500
					return c.errors
				end
			else
				status 500
				return p.errors
			end
		end

		desc "Detail a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
			
			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate
			#c = e.candidates.find_by_object_id(params[:ocdid])

			# temporary until elections work
			c = Vssc::Candidate.find_by_object_id(params[:ocdid])

			if c
				p = Vssc::Person.where(id: c.person_identifier).first
				if p
					status 200
					return [c,p]
				else
					status 400
					error_not_found(params[:ocdid])
				end
			else
				status 400
				error_not_found(params[:ocdid])
			end
		end

		desc "Update a candidate"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false


			requires :ballot_name, type: String
			requires :party_ocdid, type: String, desc: "ocdid of affiliated party."

			# 'person' subclass here
			requires :first_name, type: String
			requires :middle_name, type: String
			requires :last_name, type: String
			requires :prefix, type: String
			requires :suffix, type: String
			requires :profession, type: String
		end
		post :update do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:ballot_name])
			validate_string_name(params[:first_name])
			validate_string_name(params[:middle_name])
			validate_string_name(params[:last_name])
			validate_string_name(params[:prefix])
			validate_string_name(params[:suffix])
			validate_string_name(params[:profession])

			# validate that election, party IDs exist
			# error if object does not exist
			#attributes = params.dup
			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate
			#c = e.candidates.find_by_object_id(params[:ocdid])

			# temporary until elections work
			c = Vssc::Candidate.find_by_object_id(params[:ocdid])

			if c.nil?
				status 400
				error_not_found(params[:ocdid])
			end

			p = Vssc::Person.where(id: c.person_identifier).first

			if p.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected candidate/person
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				if params[:ballot_name].length > 0
					c.ballot_name.language_strings.where(language: "en-US").first.text = params[:ballot_name]
					p.full_name.language_strings.where(language: "en-US").first.text = params[:ballot_name]
				end
				if params[:first_name].length > 0
					p.first_name = params[:first_name]
				end
				if params[:middle_name].length > 0
					p.middle_names = [params[:middle_name]]
				end
				if params[:last_name].length > 0
					p.last_name = params[:last_name]
				end
				if params[:prefix].length > 0
					p.prefix = params[:prefix]
				end
				if params[:suffix].length > 0
					p.sufix = params[:suffix]
				end
				if params[:profession].length > 0
					p.profession = params[:profession]
				end
				if c.save
					if p.save
						status 200
						return [c,p]
					else
						status 500
						return p.errors
					end
				else
					status 500
					return c.errors
				end
			end
		end
	end

	resource :parties do
		desc "List all parties"
		get do
			return Vssc::Party.limit(10).collect do |p|
				{
					id: p.id,
					ocdid: p.object_id
				}
			end
		end

		desc "Create a new party"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String, allow_blank: false
			requires :color, type: String, desc: "HTML color string of party."
			requires :abbreviation, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])

			# error if object already exists			
			if Vssc::Party.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			name = Vssc::InternationalizedText.new()
			name.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:name])

			p = Vssc::Party.new(object_id: params[:ocdid], name: name, color: params[:color], abbreviation: params[:abbreviation])

			if p.save
				status 200
				return p.to_json(:include => {:name => { :include => :language_strings}})
			else
				status 500
				return p.errors
			end
		end

		desc "Detail a party"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
      		p = Vssc::Party.find_by_object_id(params[:ocdid])
			if p
				status 200
				# Include name data
				return p.to_json(:include => {:name => { :include => :language_strings}})
				#return [p, p.name.language_strings]
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update a party"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String
			requires :color, type: String, desc: "HTML color string of party."
			requires :abbreviation, type: String
		end
		post :update do
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])
			
			# error if object does not exist
			attributes = params.dup
			p = Vssc::Party.find_by_object_id(attributes.delete(:ocdid))
			if p.nil?
				status 400
				error_not_found(params[:ocdid])
			else
				# update selected party
				# TODO: attributes list needs to be sanitized and probably gem updated to allow mass assignment
				# only update if string not empty
				if params[:name].length > 0
					p.name.language_strings[0].text = params[:name]
				end
				if params[:color].length > 0
					p.color = params[:color]
				end
				if params[:abbreviation].length > 0
					p.abbreviation = params[:abbreviation]
				end
				if p.save
					status 200
					# Include name data
					return p.to_json(:include => {:name => { :include => :language_strings}})
				else
					status 500
					return p.errors
				end
			end
		end
	end

	resource :ballot_measure_contests do
		desc "List all ballot measure contests"
		params do
			requires :election_id, type: String, allow_blank: false
		end
		post do
			status 200
			return Vssc::BallotMeasureContest.limit(10).collect do |cc|
				{
					id: cc.id,
					ocdid: cc.object_id
				}
			end
		end

		desc "Create ballot measure contest"
		params do
			requires :name, type: String, allow_blank: false, desc: "Name of contest, e.g. \"Governor.\""
			requires :election_id, type: String, allow_blank: false, desc: "ocdid of election the contest is under."
			requires :scope_ocdid, type: String, allow_blank: false, desc: "OCDID of jurisdiction scope"

			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String, allow_blank: false
			requires :ballot_subtitle, type: String, allow_blank: false
			requires :ballot_measure_type, type: Integer # integer as position in enum in schema
			requires :sequence_order, type: Integer, allow_blank: false

			requires :pro_statement, type: String, allow_blank: false
			requires :con_statement, type: String, allow_blank: false
			requires :passage_threshold, type: String, allow_blank: false
			requires :full_text, type: String, allow_blank: false
			requires :summary_text, type: String, allow_blank: false
			requires :effect_of_abstain, type: String, allow_blank: false
		end
		post :create do
			validate_ocdid(params[:scope_ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])

			validate_string_text(params[:pro_statement])
			validate_string_text(params[:con_statement])
			validate_string_text(params[:passage_threshold]) # best way to validate?
			validate_string_text(params[:full_text])
			validate_string_text(params[:summary_text])
			validate_string_text(params[:effect_of_abstain])
			# create the ballot measure contest

			# error if object already exists			
			if Vssc::BallotMeasureContest.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			# verify scope ocdid exists
			s = Vssc::ReportingUnit.find_by_object_id(params[:scope_ocdid])
			if s.nil?
				status 400
				error_not_found(params[:scope_ocdid])
			end

			title = Vssc::InternationalizedText.new()
			title.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:ballot_title])
			subtitle = Vssc::InternationalizedText.new()
			subtitle.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:ballot_subtitle])

			pro = Vssc::InternationalizedText.new()
			pro.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:pro_statement])
			con = Vssc::InternationalizedText.new()
			con.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:con_statement])
			threshold = Vssc::InternationalizedText.new()
			threshold.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:passage_threshold])
			fulltext = Vssc::InternationalizedText.new()
			fulltext.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:full_text])
			summary = Vssc::InternationalizedText.new()
			summary.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:summary])
			abstain = Vssc::InternationalizedText.new()
			abstain.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:effect_of_abstain])

			#test = Vssc::BallotMeasureContest.new()
			#return test

			# ballot title and ballot sub title should not be ID fields
			cc = Vssc::BallotMeasureContest.new(object_id: params[:ocdid], name: params[:name], abbreviation: params[:abbreviation], 
				ballot_title_id: title, ballot_sub_title_id: subtitle, sequence_order: params[:sequence_order], jurisdictional_scope_identifier: params[:scope_ocdid], 
				ballot_measure_type: get_enum_by_index(Vssc::Enum::BallotMeasureType, params[:ballot_measure_type], "ballotmeasuretype"),
				pro_statement_id: pro, con_statement_id: con, passage_threshold_id: threshold, full_text_id: fulltext, summary_text: summary, effect_of_abstain_id: abstain)

			if cc.save
				status 200
				return cc
			else
				status 500
				return cc.errors
			end
		end

		desc "List detail of a ballot measure contest"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
			#e = Vssc::Election.where(id: params[:election_id]).first
			#if e.nil?
			#	status 400
			#	return error_not_found(params[:election_id])
			#end

			# confirm OCDID exists and is a candidate contest
			#cc = e.contests.find_by_object_id(params[:ocdid])

			# temporary until elections work
			cc = Vssc::BallotMeasureContest.find_by_object_id(params[:ocdid])
			if cc
				status 200
				return cc
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update ballot measure contest"
		params do
			requires :election_ocdid, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false

			requires :abbreviation, type: String, desc: "Abbreviation for contest." # required but can be empty
			requires :ballot_title, type: String
			requires :ballot_subtitle, type: String
			requires :ballot_measure_type, type: Integer # integer as position in enum in schema
			requires :sequence_order, type: Integer

			requires :pro_statement, type: String
			requires :con_statement, type: String
			requires :passage_threshold, type: String
			requires :full_text, type: String
			requires :summary_text, type: String
			requires :effect_of_abstain, type: String
		end
		post :update do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:abbreviation])
			validate_string_name(params[:ballot_title])
			validate_string_name(params[:ballot_subtitle])

			validate_string_text(params[:pro_statement])
			validate_string_text(params[:con_statement])
			validate_string_text(params[:passage_threshold]) # best way to validate?
			validate_string_text(params[:full_text])
			validate_string_text(params[:summary_text])
			validate_string_text(params[:effect_of_abstain])
			# update the selected contest

			status 200
			# dummy message for testing
			"updating ballot measure contest"
		end
	end

	resource :ballot_measure_selection do
		desc "List all ballot measure selections for a contest"
		params do
			requires :election_ocdid, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
		end
		post do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:contest_ocdid])
			status 200
			# list selections for a contest
			if params[:election_ocdid] == ocd_election
				if params[:contest_ocdid] == ocd_referendum
					[ocd_referendum_response_yes,ocd_referendum_response_no]
				else
					error_invalid(params[:contest_ocdid])
				end
			else
				error_invalid(params[:election_ocdid])
			end
		end

		desc "Create a ballot measure selection"
		params do
			requires :election_ocdid, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
			requires :selection, type: String
		end
		post :create do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:contest_ocdid])
			validate_ocdid(params[:ocdid])
			# create a ballot measure selection
			validate_ocdid_duplicate(params[:ocdid])

			# dummy message for testing
			"creating selection " + params[:selection] + " in contest " + params[:ocdid]
		end

		desc "Detail a ballot measure selection"
		params do
			requires :election_id, type: String, allow_blank: false
			requires :contest_ocdid, type: String, allow_blank: false
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:contest_ocdid])
			validate_ocdid(params[:ocdid])
			status 200
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
			requires :ocdid, type: String, allow_blank: false
			requires :selection, type: String
		end
		post :update do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:contest_ocdid])
			validate_ocdid(params[:ocdid])
			# update the selected selection

			status 200
			# dummy message for testing
			"updating"
		end
	end

	resource :contests do
		desc "List all contests under a certain election, both candidate and ballot measure"
		params do
			requires :election_id, type: String, allow_blank: false
		end
		post do
			status 200
			return Vssc::Contest.limit(10).collect do |cc|
				{
					id: cc.id,
					ocdid: cc.object_id
				}
			end
		end
	end

	resource :ballot_specs do
		desc "List all ballot specs of an election"
		params do
			requires :election_ocdid, type: String, allow_blank: false
		end
		post :list do
			validate_ocdid(params[:election_ocdid])
			# return all ballot styles of that election

			status 200
			# dummy message for testing
			['SPEC_1', 'SPEC_2', 'SPEC_3']
		end

		desc "List ballot specs of an election in a precinct"
		params do
			requires :election_ocdid, type: String, allow_blank: false
			requires :precinct_ocdid, type: String, allow_blank: false
		end
		post :precinct_list do
			validate_ocdid(params[:election_ocdid])
			validate_ocdid(params[:ocdid])
			# create a new ballot spec

			status 200
			# dummy message for testing
			['SPEC_1', 'SPEC_2', 'SPEC_3']
		end
	end

	resource :offices do
		desc "List all offices"
		get do
			return Vssc::Office.limit(10).collect do |o|
				{
					id: o.id,
					ocdid: o.object_id
				}
			end
		end

		desc "Create a new office"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String, allow_blank: false
			requires :scope_ocdid, type: String, allow_blank: false, desc: "OCDID of office's jurisdictional scope"
			requires :holder_ocdid, type: String, allow_blank: false, desc: "OCDID of current office holder"
			requires :deadline_month, type: Integer, desc: "Filing deadling month"
			requires :deadline_day, type: Integer, desc: "Filing deadline day"
			requires :deadline_year, type: Integer, desc: "Filing deadline year"
			requires :deadline_hour, type: Integer, desc: "Filing deadling hour"
			requires :deadline_minute, type: Integer, desc: "Filing deadline minute"
			requires :deadline_timezone, type: Integer, desc: "Filing deadline timezone, +UTC."
			requires :ispartisan, type: Boolean

			# Contact info portion
			requires :address_line, type: String, allow_blank: false
			requires :email, type: String, allow_blank: false
			requires :fax, type: String, allow_blank: false
			requires :contact_name, type: String, allow_blank: false
			requires :phone, type: String, allow_blank: false
			requires :uri, type: String, allow_blank: false
			# schedule here somehow

			# Term portion
			requires :term_start_month, type: Integer, allow_blank: false
			requires :term_start_day, type: Integer, allow_blank: false
			requires :term_start_year, type: Integer, allow_blank: false
			requires :term_end_month, type: Integer, allow_blank: false
			requires :term_end_day, type: Integer, allow_blank: false
			requires :term_end_year, type: Integer, allow_blank: false
			requires :term_type, type: Integer, allow_blank: false, desc: "Enum position based on enum in standard"
		end
		post :create do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:scope_ocdid])
			validate_ocdid(params[:holder_ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:contact_name])
			validate_ocdid_duplicate(params[:ocdid])
			# verify phone numbers?

			# error if object already exists
			if Vssc::Office.where(object_id: params[:ocdid]).count > 0
				error_already_exists(params[:ocdid])
			end

			# validate that scope, holder OCDIDs exist
			s = Vssc::ReportingUnit.find_by_object_id(params[:scope_ocdid])
			if s.nil?
				status 400
				error_not_found(params[:scope_ocdid])
			end
			# person or candidate?
			h = Vssc::Candidate.find_by_object_id(params[:holder_ocdid])
			if h.nil?
				status 400
				error_not_found(params[:holder_ocdid])
			end

			#c = Vssc::ContactInformation.new(address_line: [params[:address_line]], email: [params[:email]], fax: [params[:fax]],
				#name: params[:contact_name], phone: [params[:phone]], uri: [params[:uri]])

			#t = Vssc::Term(start_date: Date.new(params[:term_start_year], params[:term_start_month], params[:term_start_day]),
			#	end_date: Date.new(params[:term_end_year], params[:term_end_month], params[:term_end_day]),
			#	type: get_enum_by_index(Vssc::Enum::OfficeTermType, params[:term_type], "officetermtype"))

			oname = Vssc::InternationalizedText.new()
			oname.language_strings << Vssc::LanguageString.new(language: "en-US", text: params[:name])

			# How does office holder work
			o = Vssc::Office.new(object_id: params[:ocdid], name: oname, jurisdictional_scope_identifier: params[:scope_ocdid],
				filing_deadline: DateTime.new(params[:deadline_year], params[:deadline_month], params[:deadline_day], 
					params[:deadline_hour], params[:deadline_minute], 0, params[:deadline_timezone]),
				is_partisan: params[:ispartisan])
			# contact_information: c, term: t, 

			#if c.save
			#	if t.save
			#		if p.save
			#			return [p,c,t]
			#		else
			#			status 500
			#			return p.errors
			#		end
			#	else
			#		status 500
			#		return t.errors
			#	end
			#else
			#	status 500
			#	return c.errors
			#end

			if o.save
				#return [o,c,t]
				return o
			else
				status 500
				return o.errors
			end
		end

		desc "Detail an office"
		params do
			requires :ocdid, type: String, allow_blank: false
		end
		post :read do
			validate_ocdid(params[:ocdid])
      		o = Vssc::Office.find_by_object_id(params[:ocdid])
			if o
				status 200
				return o
			else
				# error if object does not exist
				status 404
				error_not_found(params[:ocdid])
			end
		end

		desc "Update an office"
		params do
			requires :ocdid, type: String, allow_blank: false
			requires :name, type: String
			# guessing unable to update scope OCDID
			requires :holder_ocdid, type: String, allow_blank: false, desc: "OCDID of current office holder"
			requires :deadline_month, type: Integer, desc: "Filing deadling month"
			requires :deadline_day, type: Integer, desc: "Filing deadline day"
			requires :deadline_year, type: Integer, desc: "Filing deadline year"
			requires :ispartisan, type: Boolean

			# Contact info portion
			requires :address_line, type: String
			requires :email, type: String
			requires :fax, type: String
			requires :contact_name, type: String
			requires :phone, type: String
			requires :uri, type: String
			# schedule here somehow

			# Term portion
			requires :term_start_month, type: Integer
			requires :term_start_day, type: Integer
			requires :term_start_year, type: Integer
			requires :term_end_month, type: Integer
			requires :term_end_day, type: Integer
			requires :term_end_year, type: Integer
			requires :term_type, type: Integer, desc: "Enum position based on enum in standard"

		end
		post :update do
			validate_ocdid(params[:ocdid])
			validate_ocdid(params[:holder_ocdid])
			validate_string_name(params[:name])
			validate_string_name(params[:contact_name])
			# update the office

			status 200
			# dummy message for testing
			"updating the office"
		end
	end

end