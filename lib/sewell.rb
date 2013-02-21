#coding:utf-8
require "sewell/version"

module Sewell
  # Your code goes here...
  def self.generate args, tables
    raise TypeError unless tables.class == Array
    case args.class.to_s
    when 'String'
      from_str args, tables
    else
      raise TypeError
    end
  end

  private

  def self.from_str str, tables
    str.gsub!(/　/, ' ')
    q = []
    str.split(' ').map{|x| 
      q << x and next if x == 'OR' or x == 'AND'
      if x.scan(/:/).count == 1
        table = x.split(':').first
        word = x.split(':').last
        q << "( #{table}:@#{sanitize word, /#{table}\:/} )"
      else
        q << '( ' + tables.map{|t| "#{t}:@#{sanitize(x)}"}.join(' OR ') + ' )'
      end
    }
    q.join ' '
  end

  def self.sanitize query, *ex
    if ex.first
      query.gsub!(ex.first, '')  
    end
    query.gsub(/(:|<|>|\[|\]|\(|\))/, ' ')
  end
end
