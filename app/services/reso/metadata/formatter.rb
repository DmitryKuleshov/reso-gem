module Reso
  module Metadata
    class Formatter
      def initialize(format: :xml, data: nil)
        @format = format
        @data = data
      end

      def format
        if @format == :xml
          xml = Nokogiri::XML('<?xml version = "1.0" encoding = "UTF-8" standalone = "yes"?>')
          builder = Nokogiri::XML::Builder.with(xml) do |xml|
            xml.send('edmx:Edmx', { 'xmlns:edmx': 'http://docs.oasis-open.org/odata/ns/edmx', Version: "4.0" }) {
              self.send("draw_#{@data.class.name.downcase.split('::').last}_xml", @data, xml)
            }
          end

          builder.to_xml
        else
        end
      end

      private

      def draw_dataserviceobject_xml(data, xml)
        xml.send('edmx:DataServices') {
          if data.resources.present?
            draw_resourceobjects_xml(data.resources, xml)
            draw_enumobjects_xml(data.enums, xml)
            draw_containerobjects_xml(data.enums, xml)
            draw_metadata_xml(xml)
          end
        }
      end

      def draw_resourceobjects_xml(data, xml)
        xml.send('Schema', { xmlns: 'http://docs.oasis-open.org/odata/ns/edm', Namespace: 'ODataService' }) {
          data.each do |resource|
            xml.EntityType( Name: resource.name) {
              xml.Key( Name: resource.name) {
                xml.PropertyRef( Name: resource.key_field)
              }

              resource.columns.each do |_column_name, column_data|
                xml.Property(column_data[:attributes]) {
                  xml.Annotation(column_data[:annotation])
                }
              end

              resource.reflections.each do |reflection_data|
                xml.NavigationProperty(reflection_data)
              end
            }
          end
        }
      end

      def draw_enumobjects_xml(data, xml)
          data.each do |resource|
            xml.send('Schema', { xmlns: 'http://docs.oasis-open.org/odata/ns/edm', Namespace: "#{resource.name}Enums" }) {
              resource.enums.each do |_field_name, enum|
                xml.EnumType(enum[:attributes]) {
                  enum[:values].each { |value| xml.Member( Name: value)} if enum[:values].present?
                }
              end
            }
          end
      end

      def draw_containerobjects_xml(data, xml)
        xml.send('Schema', { xmlns: 'http://docs.oasis-open.org/odata/ns/edm', Namespace: 'Default' }) {
          xml.EntityContainer('Name': 'Container') {
            data.each do |container|
              xml.EntitySet('Name': container.name, 'EntityType': "ODataService.#{container.name}")
            end
          }
        }
      end

      def draw_metadata_xml(xml)
        xml.send('Schema', { xmlns: 'http://docs.oasis-open.org/odata/ns/edm', Namespace: 'RESO.OData.Metadata' }) {
          xml.Term('Name': "StandardName", 'Type': "Edm.String") {
            xml.Annotation('Term': "Org.OData.Core.V1.Description", 'String': 'The standard name of the entity, property, enumeration, or enumeration value')
          }
        }
      end
    end
  end
end
