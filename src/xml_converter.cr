require "xml"
require "./ext/xml/node"

# Class to convert `XML::Node` or `String` object to `Hash`.
#
# Simple example:
#
# ```
# xml = <<-XML
#   <person id="1">
#     <firstname>Jane</firstname>
#     <lastname>Doe</lastname>
#     </person>
#   XML
#
# document = XML.parse(xml)
# hash = XMLConverter.new(document, content_key: :_value, collapse: false).to_h
# => {"person" => {"id" => "1", "firstname" => {:_value => "Jane"}, "lastname" => {:_value => "Doe"}}}
# ```
#
# Options:
#
# `content_key` - name for text property for elements with attributes and text
# `collapse` - collapse elements that only contain text into a simple string property.
class XMLConverter
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  alias HashKey = String | Symbol
  alias Type = HashKey | Array(Type) | Hash(HashKey, Type)

  getter content_key : Symbol

  def initialize(content : String, @content_key = :value, @collapse = true)
    xml = XML.parse(content)
    initialize(xml, @content_key, @collapse)
  end

  def initialize(@xml : XML::Node, @content_key = :value, @collapse = true)
  end

  def to_h
    parse(@xml)
  end

  private def parse(data : XML::Node)
    if root = data.root
      merge_element!({} of HashKey => Type, root)
    end
  end

  private def merge_element!(hash, element : XML::Node)
    merge!(hash, element.name, collapse(element))
  end

  private def merge!(hash, key : HashKey, value : Type)
    if hash[key]?
      if hash[key].is_a?(Array)
        hash[key].as(Array) << value
      else
        hash[key] = [hash[key], value] of Type
      end
    else
      hash[key] = value
    end

    hash
  end

  private def collapse(element : XML::Node)
    hash = get_attributes(element)

    if element.has_elements?
      element.elements.each { |child| merge_element!(hash, child) }
      merge_texts!(hash, element) unless empty_content?(element)
      hash
    else
      merge_texts!(hash, element)
    end
  end

  private def merge_texts!(hash, element)
    if element.has_text?
      texts = String::Builder.build do |io|
        element.texts.each { |text| io << text.text }
      end.to_s

      if element.has_attributes? || !@collapse
        merge!(hash, @content_key, texts.strip)
      else
        texts.strip
      end
    else
      hash
    end
  end

  private def empty_content?(element : XML::Node)
    element.texts.join.strip.empty?
  end

  private def get_attributes(element : XML::Node)
    attributes = {} of HashKey => Type
    element.attributes.each { |attr| attributes[attr.name] = attr.content }
    attributes
  end
end
