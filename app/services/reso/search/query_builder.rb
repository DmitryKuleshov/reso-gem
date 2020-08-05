module Reso
  module Search
    class QueryBuilder
      SIMPLE_DELIMITERS = { 'eq' => '=', 'ge' => '>=', 'le' => '<=', 'gt' => '>', 'lt' => '<', 'ne' => '<>' }
      METHOD_DELIMITERS = %w(contains endswith startswith)
      GEO_DELIMITERS = %w(geo.intersects)


      def initialize(where: nil, resource: nil, limit: nil, offset: nil, select: ['*'])
        @where = where
        @resource = resource
        @limit =limit
        @offset = offset
        @select = select
      end

      def build
        [select_build, from_build, where_build, order_build, limit_build, offset_build].compact.reject { |c| c.empty? }.join(' ')
      end

      def build_count
        select = 'SELECT COUNT(*)'

        [select, from_build, where_build].join(' ')
      end

      def select_build
        @selected_columns = if @select == ['*']
                              @select
                            else
                              @select.map do |column|
                                if @resource.available_reso_field?(column)
                                  @resource.rails_name_for_reso_field(column)
                                else
                                  raise ResoError.new(:InvalidSelect, extend_message: "#{column}")
                                end
                              end.compact + @resource.default_select_columns
                            end

        "SELECT #{@selected_columns.join(', ')}"
      end

      def from_build
        "FROM #{@resource.table_name}"
      end

      def limit_build
        return '' unless (@limit.present? && @limit.to_i > 0)
        "LIMIT #{@limit.to_i}"
      end

      def offset_build
        return unless (@offset.present? && @offset.to_i > 1)
        "OFFSET #{@offset.to_i - 1}"
      end

      def order_build
        "ORDER BY #{@resource.sort_field}" if @resource.key_field.present?
      end

      def where_build
        return unless @where.present?
        where_string = ''

        where_length = @where.length - 1
        current_condition = ''
        current_condition_delimiter = ''
        find_condition = false

        @where.each_char.with_index(0) { |c, i|
          if find_condition
            current_condition << c
            if i == where_length || (%w(d r).include?(c) && (@where[i-2..i] == ' or' || @where[i-3..i] == ' and'))
              if i == where_length
                where_string << translate_condition(current_condition, current_condition_delimiter)
              elsif %w(d r).include?(c) && (@where[i-2..i] == ' or' || @where[i-3..i] == ' and')
                if @where[i-2..i] == ' or'
                  where_string << (translate_condition(current_condition[0, current_condition.length - 3], current_condition_delimiter) + ' OR')
                else
                  where_string << (translate_condition(current_condition[0, current_condition.length - 4], current_condition_delimiter) + ' AND')
                end

              end

              find_condition = false
              current_condition_delimiter = ''
              current_condition = ''
            end
          else
            if %w(e t q).include?(c) && [' ge', ' le', ' gt', ' lt', ' ne', ' eq'].include?(@where[i-2..i])
              find_condition = true
              current_condition_delimiter = @where[i-1..i]
            elsif %w(s h) && (%w(contains endswith).include?(@where[i-7..i]) || 'startswith' == @where[i-9..i])
              find_condition = true
              current_condition_delimiter = %w(contains endswith).include?(@where[i-7..i]) ? @where[i-7..i] : @where[i-9..i]
            elsif %w(s) && 'geo.intersects' == @where[i-13..i]
              find_condition = true
              current_condition_delimiter = @where[i-13..i]
            else
            end
            current_condition << c
          end
        }

        "WHERE #{where_string}" if where_string.present?
      end

      private

      def translate_condition(condition, delimiter)
        if SIMPLE_DELIMITERS.keys.include?(delimiter)

          condition_parts = condition.split(" #{delimiter} ")
          reso_field_name_part, field_name_part, reso_field_name = prepared_field_name(condition_parts[0].gsub(/(^ *not \(*)|(\(not \()/, '').gsub(/^ *\(*/, '').strip)

          condition_parts[0] = condition_parts[0].gsub(reso_field_name_part, field_name_part).gsub('not', 'NOT')

          value = "#{condition_parts[1]}".split(' ')[0].gsub(/[\)]*$/, '')
          condition_parts[1] = condition_parts[1].gsub(value, prepared_value(value, reso_field_name))

          condition_parts.join(" #{SIMPLE_DELIMITERS[delimiter]} ")
        elsif METHOD_DELIMITERS.include?(delimiter)
          condition_parts = condition.split("#{delimiter}")
          condition_parts[0] = condition_parts[0].gsub('not', 'NOT')
          closing_bracket_position = condition_parts[1].index(')')

          if (condition_parts[1].include?('tolower(') || condition_parts[1].include?('toupper('))
            closing_bracket_position = condition_parts[1].index(')', closing_bracket_position+1)
          end

          reso_field_name_and_value_string = condition_parts[1][1..closing_bracket_position-1]
          reso_field_name_part, value = reso_field_name_and_value_string.split(',')

          _reso_field_name_part, prepared_reso_field_name_part, reso_field_name = prepared_field_name(reso_field_name_part)

          prepared_condition = "#{prepared_reso_field_name_part} LIKE "
          prepared_condition += case delimiter
                                when 'contains'
                                  "'%#{ prepared_value(value, reso_field_name, true) }%'"
                                when 'endswith'
                                  "'%#{ prepared_value(value, reso_field_name, true) }'"
                                when 'startswith'
                                  "'#{ prepared_value(value, reso_field_name, true) }%'"
                                end

          condition_parts[0] + condition_parts[1].gsub("(#{reso_field_name_and_value_string})", prepared_condition)
        elsif GEO_DELIMITERS.include?(delimiter)
          condition_parts = condition.split("#{delimiter}")
          condition_parts[0] = condition_parts[0].gsub('not', 'NOT')

          first_position = condition_parts[1].index("'")
          closing_bracket_position = condition_parts[1].index("'", first_position+1) + 1

          reso_field_name_and_value_string = condition_parts[1][1..closing_bracket_position-1]

          reso_field_name_part = reso_field_name_and_value_string[0..reso_field_name_and_value_string.index(',')-1]
          value = reso_field_name_and_value_string[reso_field_name_and_value_string.index(',')+1..-1]

          reso_field_name_part, prepared_reso_field_name_part, reso_field_name = prepared_field_name(reso_field_name_part)

          condition.gsub(delimiter, 'ST_Intersects')
              .gsub(reso_field_name_part, prepared_reso_field_name_part)
              .gsub(value[1..-2], prepare_string(value[1..-2]))
        end
      end

      def prepared_field_name(name_part)
        reso_field_name = if name_part.include?('tolower') || name_part.include?('toupper')
                            name_part.gsub(/(toupper|tolower|\(|\))/, '')
                          elsif name_part.include?('geo.distance')
                            name_part.gsub('geo.distance(', '').split(',')[0]
                          else
                            name_part
                          end

        if @resource.available_reso_field?(reso_field_name)
          field_name = @resource.rails_name_for_reso_field(reso_field_name)
        else
          raise ResoError.new(:CannotFindProperty, extend_message: "#{reso_field_name}")
        end

        prepared_name_part = if name_part.include?('geo.distance')
                               inc_value = name_part.split(',')[1].strip
                               prepared_value = "'#{inc_value[0..inc_value.index(')')]}'"

                               name_part.gsub('geo.distance', 'ST_Distance').gsub(inc_value[0..inc_value.index(')')], prepared_value)
                             else
                               name_part.gsub('tolower', 'LOWER').gsub('toupper', 'UPPER')
                             end
        prepared_name_part = prepared_name_part.gsub(reso_field_name, field_name)

        [name_part, prepared_name_part, reso_field_name]
      end

      def prepared_value(value, reso_field_name, is_value_for_method = false)
        case @resource.type_for_reso_field(reso_field_name).type
        when :string, :text
          v = prepare_string(value.gsub(/^'|'$/, ''))

          is_value_for_method ? v : "'#{v}'"
        when :boolean
          if %(true false).include? value
            value.upcase
          else
            raise ResoError.new(:InvalidValueType, extend_message: "#{reso_field_name}")
          end
        when :integer
          "#{value.to_i}"
        when :float, :st_point
          "#{value.to_f}"
        when :date
          if /^[1-2]\d{3}-[0-1]\d-[0-3]\d$/.match(value)
            begin
              "'#{Date.parse(value).strftime("%F")}'"
            rescue ArgumentError
              raise ResoError.new(:InvalidValueType, extend_message: "#{reso_field_name}")
            end
          else
            raise ResoError.new(:InvalidValueType, extend_message: "#{reso_field_name}")
          end
        when :datetime
          if /^[1-2]\d{3}-[0-1]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.00Z$/.match(value)
            begin
              "'#{DateTime.parse(value).strftime("%Y-%m-%dT%H:%M:%S")}'"
            rescue ArgumentError
              raise ResoError.new(:InvalidValueType, extend_message: "#{reso_field_name}")
            end
          else
            raise ResoError.new(:InvalidValueType, extend_message: "#{reso_field_name}")
          end
        else
          value
        end
      end

      def prepare_string(s)
        s.gsub("\'", "'").gsub("'", "\'")
      end
    end
  end
end