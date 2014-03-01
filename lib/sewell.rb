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

  def self.from_hash hash, s
    if s == 'OR'
      sep = 'OR'
    else
      sep = '+'
    end
    hash.map{|k,v| 
      '( ' + build(v.split(' ').map{|x|
        if x == 'OR' or x == 'AND'
          x
        else
          if x.split('').first == '-'
            x.sub!(/^-/, '')
            " - #{k}:@#{sanitize x, /#{k}\:/}"
          else
            "#{k}:@#{sanitize x, /#{k}\:/}"
          end
        end
      }) + ' )'
    }.join " #{sep} "
  end

  def self.escape_groonga str
    s = str.dup
    s.gsub!(/\"|\'|\\/, '\\&')
    s.gsub!("(", '\(')
    s.gsub!(")", '\)')
    puts s
    s
  end

  def self.from_str str, tables
    str.gsub!(/　|^:/, ' ')
    str = escape_groonga(str)
    q = []
    str.split(' ').map{|x| 
      q << x and next if x == 'OR' or x == 'AND'
      if x.scan(/:/).count == 1
        table = x.split(':').first
        word = x.split(':').last
        next unless word
        if word.split('').first == '-'
          q << "( #{table}:!#{sanitize word, /#{table}\:/} )"
        else
          q << "( #{table}:@#{sanitize word, /#{table}\:/} )"
        end
      else
        if x.split('').first == '-'
          x.sub!(/^-/, '')
          q << ' - ( ' + tables.map{|t| "#{t}:@#{sanitize(x)}"}.join(' OR ') + ' )'
        else
          q << '( ' + tables.map{|t| "#{t}:@#{sanitize(x)}"}.join(' OR ') + ' )'
        end
      end
    }
    build q
  end

  def self.build q, *s
    if s.first == 'OR'
      sep = 'OR'
    else
      sep = '+'
    end
    
    raise if q.map{|x| x =~ /^\ -\ /}.select{|x| x}.count == q.count
    
    while q.first =~ /^\ -\ /
      q.push q.shift
    end
    
    query = ''
    q.each_with_index{|x,i|
      next if x == 'OR' or x == 'AND'
      if q[i+1] == 'OR' 
        query += "#{x} OR "
      elsif q[i+1] == 'AND'
        query += "#{x} + "
      elsif q[i+1] and q[i+1] =~ /^\ -\ /
        query += x
      elsif q[i+1] != nil
        query += "#{x} #{sep} "
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
    query.gsub(/(:|<|>|\[|\])/, '')
  end
end
