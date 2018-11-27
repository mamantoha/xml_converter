require "./spec_helper"

describe XMLConverter do
  it "converts one element" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>text</hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"hash" => {"__content__" => "text"}}
    )
  end

  it "converts with nested elements" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <foo type="integer">1</foo>
          <bar type="integer">2</bar>
        </hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"hash" => {"foo" => {"type" => "integer", "__content__" => "1"}, "bar" => {"type" => "integer", "__content__" => "2"}}}
    )
  end

  it "converts array" do
    str = <<-XML
      <numbers>
        <value>1</value>
        <value>2</value>
        <value>3</value>
      </numbers>
    XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"numbers" => {"value" => [{"__content__" => "1"}, {"__content__" => "2"}, {"__content__" => "3"}]}}
    )
  end

  it "converts array with attributes" do
    str = <<-XML
      <settings>
        <servers>
          <server url="1"/>
          <server url="2"/>
        </servers>
      </settings>
    XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"settings" => {"servers" => {"server" => [{"url" => "1"}, {"url" => "2"}]}}}
    )
  end

  it "example from readme" do
    xml = <<-XML
      <person id="1">
        <firstname>Jane</firstname>
        <lastname>Doe</lastname>
      </person>
    XML

    document = XML.parse(xml)
    hash = XMLConverter.new(document).to_h

    hash.should eq(
      {"person" => {"id" => "1", "firstname" => {"__content__" => "Jane"}, "lastname" => {"__content__" => "Doe"}}}
    )
  end
end
