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
      '( ' + build(v.split(' ').map{|x|
        if x == 'OR' or x == 'AND'
          x
        else
          if x.split('').first == '-'
            x.sub!(/^-/, '')
            "#{k}:!#{sanitize x, /#{k}\:/}"
          else
            "#{k}:@#{sanitize x, /#{k}\:/}"
          end
        end
      }) + ' )'
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
        if word.split('').first == '-'
          q << "( #{table}:!#{sanitize word, /#{table}\:/} )"
        else
          q << "( #{table}:@#{sanitize word, /#{table}\:/} )"
        end
      else
        if x.split('').first == '-'
          x.sub!(/^-/, '')
          q << '( ' + tables.map{|t| "#{t}:!#{sanitize(x)}"}.join(' AND ') + ' )'
        else
          q << '( ' + tables.map{|t| "#{t}:@#{sanitize(x)}"}.join(' OR ') + ' )'
        end
      end
    }
    build q
  end

  def self.build q
    query = ''
    q.each_with_index{|x,i|
      next if x == 'OR' or x == 'AND'
      if q[i+1] == 'OR' or q[i+1] == 'AND'
        query += "#{x} #{q[i+1]} "
      elsif q[i+1] != nil
        query += "#{x} AND "
      else
        if x != 'AND' and x != 'OR'
          query += x
        end
      end
    }
    query
  end

  def self.sanitize query, *ex
    if ex.first
      query.gsub!(ex.first, '')  
    end
    query.gsub(/(:|<|>|\[|\]|\(|\))/, ' ')
  end
end
