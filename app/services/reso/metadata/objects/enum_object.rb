module Reso
  module Metadata
    module Objects
      class EnumObject
        attr_accessor :enums, :name

        def initialize(name)
          @name = name
          @resource = Reso::Resource.constantized_reso_resource(string: name)
          @enums = resource_enums || []
        end

        private

        def resource_enums
          result = @resource::ENUM_COLUMNS.each_with_object({}) do |field_name, hsh|
            hsh[field_name] = { attributes: { 'Name': @resource.reso_name_for_rails_field(field_name),
                                              'UnderlyingType': "Edm.Int32" } }

            if @resource.type_for_attribute(field_name).type == :enum
              enum_method = case field_name[-1]
                            when 's'
                              if %w(t n e).include? field_name[-2]
                                field_name
                              else
                                "#{field_name[0..-1]}es"
                              end
                            when 'y'
                              "#{field_name[0..-2]}ies"
                            when 'x'
                              "#{field_name[0..-1]}es"
                            else
                              "#{field_name}s"
                            end
              hsh[field_name] = hsh[field_name].merge({ values: @resource.send(enum_method).values })
            end
          end

          @resource::MULTI_LIST_COLUMNS.each_with_object(result) do |field_name, hsh|
            hsh[field_name] = { attributes: { 'Name': @resource.reso_name_for_rails_field(field_name),
                                              'UnderlyingType': "Edm.Int32",
                                              IsFlags: 'true' } }

            if @resource::MULTI_LIST_COLUMNS_VALUES.keys.include?(field_name.to_sym)
              hsh[field_name] = hsh[field_name].merge({ values: @resource::MULTI_LIST_COLUMNS_VALUES[field_name.to_sym] })
            end
          end

          result
        end
      end
    end
  end
end