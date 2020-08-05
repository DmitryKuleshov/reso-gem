module Reso
	class Resource < ActiveRecord::Base

		self.abstract_class = true

		def self.key_field
			raise 'Not implemented'
		end

		def self.reso_key_field
			self.reso_name_for_rails_field(self.key_field)
		end

		def self.sort_field
			self.key_field
		end

		def self.default_select_columns
			[self.key_field]
		end

		def self.constantized_reso_resource(string: nil)
			case string
			when 'Property' then ResoProperty
			when 'Office' then ResoOffice
			when 'Media' then ResoMedia
			when 'Member' then ResoMember
			when 'OpenHouse' then ResoOpenHouse
			else
				nil
			end
		end

		def self.reso_name_for_rails_field(field_name = '')
			field_name.gsub('_', ' ').titlecase.gsub(' ', '')
		end

		def self.rails_name_for_reso_field(field_name = '')
			field_name.gsub(/([A-Z])/, '_\1')[1..-1].downcase
		end

		def self.available_reso_field?(field_name)
			column_names.include? rails_name_for_reso_field(field_name)
		end

		def self.type_for_reso_field(field_name)
			type_for_attribute(rails_name_for_reso_field(field_name))
		end

		def self.reso_attributes
			column_names - %w(id created_at updated_at)
		end
	end
end