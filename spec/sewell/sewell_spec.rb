require 'spec_helper'
require 'sewell'

describe Sewell do
  it 'raise TypeError unless input String' do
    lambda{Sewell.generate [], []}.should raise_error(TypeError)
  end

  it 'can generate from string' do
    Sewell.generate('sena:airi OR mashiro AND nuko:buta', %w{sena uryu nuko}).should == '( sena:@airi ) OR ( sena:@mashiro OR uryu:@mashiro OR nuko:@mashiro ) + ( nuko:@buta )'
    Sewell.generate('-inui airi', ['mashiro']).should == '( mashiro:@airi ) - ( mashiro:@inui )'
  end

  it 'can generate from hash' do
    Sewell.generate({sena: 'airi OR huro', nuko: 'trape'}, 'AND').should == '( sena:@airi OR sena:@huro ) + ( nuko:@trape )'
    Sewell.generate({mashiro: '-inui airi'}, 'AND').should == '( mashiro:@airi - mashiro:@inui )'
  end

  it 'can generate with "-"' do
    Sewell.generate('ビジュメニア - Single', ['buta']).should == "( buta:@ビジュメニア ) + ( buta:@Single )"
  end

  it 'can use "" with OR' do
    Sewell.generate('"Rainy veil" OR あなたの愛した世界', ['buta']).should == "( buta:@\"Rainy veil\" ) OR ( buta:@あなたの愛した世界 )"
    Sewell.generate('あなたの愛した世界 OR "Rainy veil"', ['buta']).should == "( buta:@あなたの愛した世界 ) OR ( buta:@\"Rainy veil\" )"
  end
end
