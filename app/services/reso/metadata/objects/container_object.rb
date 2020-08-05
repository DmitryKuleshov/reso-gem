module Reso
  module Metadata
    module Objects
      class ContainerObject
        attr_accessor :name

        def initialize(name)
          @name = name
          @resource = Reso::Resource.constantized_reso_resource(string: name)
        end
      end
    end
  end
end