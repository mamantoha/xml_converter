require "./spec_helper"

describe XMLConverter do
  it "works" do
    str = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <foo type="integer">1</foo>
          <bar type="integer">2</bar>
        </hash>
    XML

    xml = XML.parse(str)

    hash = Hash.from_xml(xml)

    hash.should eq({"hash" => {"foo" => 1, "bar" => 2}})
  end
end
