require "xml"
require "./ext/xml/node"

class XMLConverter
  VERSION = "0.1.0"

  alias HashKey = String | Symbol
  alias Type = HashKey | Array(Type) | Hash(HashKey, Type)

  getter content_key : Symbol

  def initialize(content : String, @content_key = :value)
    xml = XML.parse(content)
    initialize(xml, @content_key)
  end

  def initialize(@xml : XML::Node, @content_key = :value)
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

      merge!(hash, @content_key, texts.strip)
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
