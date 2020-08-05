module Reso
  module Metadata
    class Generator
      def self.generate
        Reso::Metadata::Objects::DataServiceObject.new
      end
    end
  end
end
