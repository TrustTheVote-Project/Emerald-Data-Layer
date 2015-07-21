module Jurisdiction
	class Data < Grape::API

		resource :list_jurisdictions do 
			desc "List jurisdiction data"

			get do
				# return list of name, ID of each jurisdiction

				# dummy message for testing
				content_type 'text/plain'
				body 'OK'
			end
		end

		resource :create_jurisdiction do
			desc "Create new jurisdiction, manually inputting parameters"

			params do
				requires :name, type: String
			end

			post do
				# create jurisdiction
				# params allowed are name (required), 

				# dummy message for testing
				content_type 'text/plain'
				body "creating jurisdiction" + params[:name]
			end
		end

		resource :import_jurisdiction do
			desc "Import jurisdiction"

			params do
				# only the data string
				requires :info, type: String
			end

			post do
				# parse and create jurisdiction
			end
		end

		resource :update_contactinfo do
			desc "Add contact info to jurisdiction"

			# No strings in contact info are 'required,' no assert
			# params

			post do
				# add contact info to jurisdiction

				# dummy message for testing
				content_type 'text/plain'
				body "creating jurisdiction" + params[:name]
			end
		end
	end
end