require "./spec_helper"

describe XMLConverter do
  describe "#initializer" do
    it "initialize XMLConverter with XML::Node" do
      str = <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
       XML

      xml = XML.parse(str)
      xml_converter = XMLConverter.new(xml)
      xml_converter.content_key.should eq(:value)
    end

    it "initialize XMLConverter with String" do
      str = <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
       XML

      xml_converter = XMLConverter.new(str)
      xml_converter.content_key.should eq(:value)
    end

    it "initialize XMLConverter with XML::Node and custom content key" do
      str = <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
       XML

      xml = XML.parse(str)
      xml_converter = XMLConverter.new(xml, :__value__)
      xml_converter.content_key.should eq(:__value__)
    end
  end

  it "converts one element with value" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>text</hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"hash" => "text"}
    )
  end

  it "converts one element with value and not collapse" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>text</hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml, collapse: false).to_h

    hash.should eq(
      {"hash" => {:value => "text"}}
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
      {"hash" => {"foo" => {"type" => "integer", :value => "1"}, "bar" => {"type" => "integer", :value => "2"}}}
    )
  end

  it "strip content" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <foo>
            1
          </foo>
        </hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml).to_h

    hash.should eq(
      {"hash" => {"foo" => "1"}}
    )
  end

  context "converts array" do
    str = <<-XML
      <numbers>
        <value>1</value>
        <value>2</value>
        <value>3</value>
      </numbers>
    XML

    xml = XML.parse(str)

    it "with collapse" do
      hash = XMLConverter.new(xml).to_h

      hash.should eq(
        {"numbers" => {"value" => ["1", "2", "3"]}}
      )
    end

    it "without collapse" do
      hash = XMLConverter.new(xml, collapse: false).to_h

      hash.should eq(
        {"numbers" => {"value" => [{:value => "1"}, {:value => "2"}, {:value => "3"}]}}
      )
    end
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
        <firstName preferredName="Jane">Jehanne</firstname>
        <lastName>Doe</lastname>
      </person>
    XML

    document = XML.parse(xml)
    hash = XMLConverter.new(document).to_h

    hash.should eq(
      {"person" => {"id" => "1", "firstName" => {"preferredName" => "Jane", :value => "Jehanne"}, "lastName" => "Doe"}}
    )
  end

  it "allows to set custom content key" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>text</hash>
     XML

    xml = XML.parse(str)
    hash = XMLConverter.new(xml, content_key: :__value__, collapse: false).to_h

    hash.should eq(
      {"hash" => {:__value__ => "text"}}
    )
  end
end
