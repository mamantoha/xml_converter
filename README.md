# XMLConverter

[![CI](https://github.com/mamantoha/xml_converter/actions/workflows/crystal.yml/badge.svg)](https://github.com/mamantoha/xml_converter/actions/workflows/crystal.yml)

Create hashes from XML documents easily.

`xml_converter` is heavily inspired by [ActiveSupport::XMLConverter](https://api.rubyonrails.org/classes/ActiveSupport/XMLConverter.html).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     xml_converter:
       github: mamantoha/xml_converter
   ```

2. Run `shards install`

## Usage

```crystal
require "xml_converter"

xml = <<-XML
  <person id="1">
    <firstName preferredName="Jane">Jehanne</firstname>
    <lastName>Doe</lastname>
  </person>
XML

document = XML.parse(xml)
hash = XMLConverter.new(document).to_h
# => {"person" => {"id" => "1", "firstName" => {"preferredName" => "Jane", :value => "Jehanne"}, "lastName" => "Doe"}}
```

## Contributing

1. Fork it (<https://github.com/mamantoha/xml_converter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
