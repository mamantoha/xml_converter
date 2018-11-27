# xml_converter

[![Build Status](https://travis-ci.org/mamantoha/xml_converter.svg?branch=master)](https://travis-ci.org/mamantoha/xml_converter)

Create hashes from XML documents easily.

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
    <firstname>Jane</firstname>
    <lastname>Doe</lastname>
  </person>
XML

document = XML.parse(xml)
hash = Hash.from_xml(document)
# => {"person" => {"id" => "1", "firstname" => {"__content__" => "Jane"}, "lastname" => {"__content__" => "Doe"}}}
```

## Contributing

1. Fork it (<https://github.com/mamantoha/xml_converter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
