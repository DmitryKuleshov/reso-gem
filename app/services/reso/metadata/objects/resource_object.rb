module Reso
  module Metadata
    module Objects
      class ResourceObject
        attr_accessor :columns, :name, :key_field, :reflections

        def initialize(name, key_field)
          @name = name
          @resource = Reso::Resource.constantized_reso_resource(string: name)
          @columns = columns_data
          @key_field = key_field
          @reflections = resource_reflections || []
        end

        def columns_data
          @resource.reso_attributes.each_with_object({}) do |field_name, hsh|
            additional_metadata_info = @resource::RESO_METADATA_FIELDS.include?(field_name.to_sym) ? @resource::RESO_METADATA_FIELDS[field_name.to_sym]: {}
            hsh[field_name] = { attributes: { 'Name': @resource.reso_name_for_rails_field(field_name),
                                              'Type': reso_type_for_field_name(field_name) }.merge(additional_metadata_info),
                                annotation: { 'Term': 'Core.Description',
                                              'String': 'Description' } }
          end
        end

        private

        def reso_type_for_field_name(field_name)
          case @resource.type_for_attribute(field_name).type
          when :integer
            'Edm.Int64'
          when :string, :geography
            if @resource::ENUM_COLUMNS.include? field_name
              "#{@resource.resource_name}Enums.#{@resource.reso_name_for_rails_field(field_name)}"
            elsif @resource::MULTI_LIST_COLUMNS.include? field_name
              "Collection(#{@resource.resource_name}Enums.#{@resource.reso_name_for_rails_field(field_name)})"
            else
              'Edm.String'
            end
          when :datetime
            'Edm.DateTimeOffset'
          when :date
            'Edm.Date'
          when :float
            'Edm.Double'
          when :boolean
            'Edm.Boolean'
          when :enum
            "#{@resource.resource_name}Enums.#{@resource.reso_name_for_rails_field(field_name)}"
          when :jsonb
            'Edm.Collection'
          else
            ''
          end
        end

        def resource_reflections
          #@resource.reflections.map do |field_name, reflection|
          #  { 'Name': @resource.reso_name_for_rails_field(field_name),
          #    'Type': "self.#{reflection.klass.resource_name}" }
          #end
        end
      end
    end
  end
end