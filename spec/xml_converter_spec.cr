require "./spec_helper"

describe XMLConverter do
  it "converts one element" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>text</hash>
     XML

    xml = XML.parse(str)
    hash = Hash.from_xml(xml)
    hash.should eq({"hash" => {"__content__" => "text"}})
  end

  it "converts with nested attributes" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <foo type="integer">1</foo>
          <bar type="integer">2</bar>
        </hash>
     XML

    xml = XML.parse(str)
    hash = Hash.from_xml(xml)
    hash.should eq({"hash" => {"foo" => {"type" => "integer", "__content__" => "1"}, "bar" => {"type" => "integer", "__content__" => "2"}}})
  end

  it "converts with array" do
    str = <<-XML
      <settings>
        <servers>
          <server url="1"/>
          <server url="2"/>
        </servers>
      </settings>
    XML

    xml = XML.parse(str)
    hash = Hash.from_xml(xml)
    hash.should eq({"settings" => {"servers" => {"server" => [{"url" => "1"}, {"url" => "2"}]}}})
  end
end
