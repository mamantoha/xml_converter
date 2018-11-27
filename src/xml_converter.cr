require "xml"

struct XML::Node
  # Get an array of all Element children.
  def elements
    children.select(&.element?)
  end

  # Get an array of all Text children.
  def texts
    children.select(&.text?)
  end

  # Evaluates to `true` if this element has at least one child Element.
  def has_elements? : Bool
    !elements.empty?
  end

  # Evaluates to `true` if this element has at least one Text child.
  def has_text? : Bool
    !texts.empty?
  end
end

class Hash
  # Returns a Hash containing a collection of pairs when the key is the node name and the value is
  # its content.
  def self.from_xml(xml : XML::Node)
    XMLConverter.new(xml).to_h
  end
end

class XMLConverter
  VERSION = "0.1.0"

  alias Type = String | Array(Type) | Hash(String, Type)

  def initialize(@xml : XML::Node, @content_key = "__content__")
  end

  def to_h
    parse(@xml)
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

      merge!(hash, @content_key, texts)
    else
      hash
    end
  end

  private def empty_content?(element : XML::Node)
    element.texts.join.strip.empty?
  end

  private def get_attributes(element : XML::Node)
    attributes = {} of String => Type
    element.attributes.each { |attr| attributes[attr.name] = attr.content }
    attributes
  end
end
