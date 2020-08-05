module Reso
  module Search
    class Formatter
      def self.format(records_count: 0, data: [], resource: nil, context_link: nil, next_link: nil)

        result = { "@odata.context": context_link }
        (result["@odata.nextLink"] = next_link) if next_link.present?
        result["@odata.count"] = records_count
        result["value"] = formatted_data(data, resource)

        result.to_json
      end

      def self.format_item(data: {}, resource: nil)
        formatted_item(data, resource).to_json
      end

      private

      def self.formatted_data(data, resource)
        data.map do |data_item|
          formatted_item(data_item, resource)
        end
      end

      def self.formatted_item(data_item, resource)
        data_item.except(:created_at, :updated_at, :id).each_with_object({}) do |(key, value), hsh|
          if %i(@odata.context @odata.id).include? key
            hsh[key] = value
          else
            hsh[resource.reso_name_for_rails_field(key)] = formatted_value(resource, key, value)
          end
        end
      end

      def self.formatted_value(resource, field_name, value)
        return until value

        case resource.type_for_attribute(field_name).type
        when :datetime
          value.strftime("%Y-%m-%dT%H:%M:%SZ")
        #when :date
        #  value.strftime("%F")
        when :string
          if resource::MULTI_LIST_COLUMNS.include? field_name
            YAML.load(value).keys
          else
            value
          end
        else
          value
        end
      end
    end
  end
end
