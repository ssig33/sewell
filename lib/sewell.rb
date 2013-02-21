#coding:utf-8
require "sewell/version"

module Sewell
  # Your code goes here...
  def self.generate args, args2
    case args.class.to_s
    when 'String'
      raise TypeError unless args2.class == Array
      from_str args, args2
    when 'Hash'
      from_hash args, args2
    else
      raise TypeError
    end
  end

  private

  def self.from_hash hash, sep
    hash.map{|k,v| 
      '( ' + v.split(' ').map{|x|
        if x == 'OR' or x == 'AND'
          x
        else
          "#{k}:@#{sanitize x, /#{k}\:/}"
        end
      }.join(' ') + ' )'
    }.join " #{sep} "
  end

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
