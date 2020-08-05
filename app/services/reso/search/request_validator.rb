module Reso
	module Search
		class RequestValidator

			attr_accessor :resource, :select, :filter, :top, :skip, :filter

			def initialize(params={}, maximum_records: nil, reso_user: nil)
				@resource = params[:resource]
				@select = params['$select'].present? ? params['$select'] : '*'
				@filter = params['$filter']
				@top = params['$top']
				@skip = params["$skip"]
				@maximum_records = maximum_records
			end

			def valid?
				if @filter.blank?
					raise ResoError.new(:MiscellaneousSearchError, extend_message: "$filter is required")
				end

				# Ensure SearchType is valid
				if Reso::Constants::RESOURCE_NAMES[:READABLE].exclude?(@resource)
					raise ResoError.new(:MiscellaneousSearchError, extend_message: "Invalid resource: #{@resource || "null"}")
				end

				# Ensure Top is valid
				if @limit and @maximum_records and @limit.to_i > @maximum_records
					raise ResoError.new(:MiscellaneousSearchError, extend_message: "Maximum value for $top is #{@maximum_records}")
				end

				return true
			end
		end
	end
end