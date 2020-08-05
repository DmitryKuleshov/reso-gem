module Reso
  module Metadata
    module Objects
      class DataServiceObject
        attr_accessor :resources, :enums, :containers

        def initialize
          @resources = system_resources
          @enums = system_enums
          @containers = system_containers
        end

        private

        def system_resources
          reso_resources = Reso::Constants::RESOURCE_NAMES[:READABLE]
          reso_resources.map do |resource|
            Reso::Metadata::Objects::ResourceObject.new(resource,
                                                        Reso::Resource.constantized_reso_resource(string: resource).reso_key_field)
          end.compact
        end

        def system_enums
          Reso::Constants::RESOURCE_NAMES[:READABLE].map do |resource|
            Reso::Metadata::Objects::EnumObject.new(resource)
          end.compact
        end

        def system_containers
          Reso::Constants::RESOURCE_NAMES[:READABLE].map do |resource|
            Reso::Metadata::Objects::ContainerObject.new(resource)
          end.compact
        end
      end
    end
  end
end