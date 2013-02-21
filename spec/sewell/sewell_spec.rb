require 'spec_helper'
require 'sewell'

describe Sewell do
  it 'raise TypeError unless input String' do
    lambda{Sewell.generate [], []}.should raise_error(TypeError)
  end

  it 'can generate from string' do
    Sewell.generate('sena:airi OR mashiro AND nuko:buta', %w{sena uryu nuko}).should == '( sena:@airi ) OR ( sena:@mashiro OR uryu:@mashiro OR nuko:@mashiro ) AND ( nuko:@buta )'
  end

  it 'can generate from hash' do
    Sewell.generate({sena: 'airi OR huro', nuko: 'trape'}, 'AND').should == '( sena:@airi OR sena:@huro ) AND ( nuko:@trape )'
  end
end
