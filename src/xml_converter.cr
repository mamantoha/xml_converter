require "xml"

class Hash
  def self.from_xml(xml : XML::Node)
    XMLConverter.new(xml).to_h
  end
end

class XMLConverter
  VERSION = "0.1.0"

  def initialize(xml : XML::Node)
    @xml = xml
  end

  def to_h
    @xml
  end
end
