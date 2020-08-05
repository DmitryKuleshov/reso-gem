module Reso
  module Search
    class Translator
      def self.translate(filter: '', resource: nil, top: nil, skip: nil, select: '*')
        Reso::Search::QueryBuilder.new(resource: resource, limit: top, offset: skip, select: select.split(','), where: filter).build
      end

      def self.translate_count(filter: '', resource: ResoProperty)
        Reso::Search::QueryBuilder.new(resource: resource, where: filter).build_count
      end
    end
  end
end
