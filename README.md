# Sewell

Generator for Groonga's query.

## Installation

Add this line to your application's Gemfile:

    gem 'sewell'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sewell

## Usage

``` ruby
  query = Sewell.generate 'sena:airi OR mashiro AND nuko:buta', %w{sena uryu nuko} #=> ( sena:@airi ) OR ( sena:@mashiro OR uryu:@mashiro OR nuko:@mashiro ) + ( nuko:@buta )
  Groonga['SenaAiri'].select(query)

  Sewell.generate({sena: 'airi OR huro', nuko: 'trape'}, 'AND') #=> ( sena:@airi OR sena:@huro ) + ( nuko:@trape )
  Sewell.generate({sena: 'airi OR huro', nuko: 'trape'}, 'OR') #=> ( sena:@airi OR sena:@huro ) OR ( nuko:@trape )

  Sewell.generate({mashiro: '-inui airi'}) #=> ( mashiro:@airi - mashiro:@inui ) 
  Sewell.generate('-inui airi', ['mashiro']) #=> ( mashiro:@airi - mashiro:@inui )
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
