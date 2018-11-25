require "xml"

struct XML::Node
  def elements
    children.select(&.element?)
  end

  def has_elements?
    !elements.empty?
  end
end

class Hash
  def self.from_xml(xml : XML::Node)
    XMLConverter.new(xml).to_h
  end
end

class XMLConverter
  VERSION = "0.1.0"

  alias Type = String | Hash(String, Type)

  def initialize(xml : XML::Node)
    @xml = xml
  end

  def to_h
    deep_to_h(@xml)
  end

  private def deep_to_h(xml)
    parse(xml)
  end

  private def parse(data : XML::Node)
    if root = data.root
      merge_element!({} of String => Type, root)
    end
  end

  private def merge_element!(hash, element : XML::Node)
    merge!(hash, element.name, collapse(element))
  end

  private def merge!(hash, key : String, value : Type)
    if hash[key]?
      hash[key] = value
    else
      hash[key] = value
    end

    hash
  end

  private def collapse(element : XML::Node)
    hash = get_attributes(element)

    if element.has_elements?
      element.elements.each { |child| merge_element!(hash, child) }
    else
    end

    hash
  end

  private def get_attributes(element : XML::Node)
    attributes = {} of String => Type
    element.attributes.each { |attr| attributes[attr.name] = attr.content }
    attributes
  end
end
