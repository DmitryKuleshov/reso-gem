#module Reso
	class ResoError < StandardError

		attr_accessor :error_name

		def initialize(error_name, extend_message: nil, override_message: nil)
			@error_name = error_name
			@override_message = override_message
			@extend_message = extend_message
		end

		def message
			if @override_message.present?
				@override_message
			else
				output_message = Reso::Errors.error_message(error_name: @error_name)
				if @extend_message
					output_message = "#{output_message}: #{@extend_message}"
				end

				return output_message
			end
		end

		def code
			Reso::Errors.error_code(error_name: @error_name)
		end

		def to_json
			{
					"error": {
							"code": code,
							"message": message
					}
			}.to_json
		end
	end
#end