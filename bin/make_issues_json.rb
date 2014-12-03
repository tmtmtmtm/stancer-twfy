#!/usr/bin/ruby

# Convert PublicWhip Policy data (fetched over the Morph.io API) 
# into Issue/Indicator data

require 'json'
require 'colorize'
require 'open-uri/cached'
require 'erb'

def morph_select(qs)
  query = qs.gsub(/\s+/, ' ').strip
  morph_api_key = ENV['MORPH_API_KEY'] or raise "Need a Morph API key"
  key = ERB::Util.url_encode(morph_api_key)
  url = 'https://api.morph.io/tmtmtmtm/publicwhip_policies/data.json' + "?key=#{key}&query=" + ERB::Util.url_encode(query)
  warn "Fetching #{url}".yellow
  return open(url).read
end

def weights_for(result, direction)
  return { yes:50, absent:25, both:25, no:0  } if direction == 'Majority (strong)' and result == 'passed'
  return { yes:0,  absent:25, both:25, no:50 } if direction == 'Majority (strong)' and result == 'failed'

  return { yes:10, absent:1,  both:1,  no:0  } if direction == 'Majority'          and result == 'passed'
  return { yes:0,  absent:1,  both:1,  no:10 } if direction == 'Majority'          and result == 'failed'

  return { yes:50, absent:25, both:25, no:0  } if direction == 'minority (strong)' and result == 'failed'
  return { yes:0,  absent:25, both:25, no:50 } if direction == 'minority (strong)' and result == 'passed'

  return { yes:10, absent:1,  both:1,  no:0  } if direction == 'minority'          and result == 'failed'
  return { yes:0,  absent:1,  both:1,  no:10 } if direction == 'minority'          and result == 'passed'

  raise "Don't know how to handle #{result} #{direction}"
end

SQL_POLICIES = 'SELECT * FROM data'

raw = morph_select(SQL_POLICIES)
divisions = JSON.parse(raw)

policies = divisions.group_by { |div| div['policy'].to_i }.map { |p, ms|
  {
    id: "PW-#{p}",
    indicators: ms.reject { |m| m['direction'] == 'abstain' }.map do |m| 
      { 
        motion_id: m['id'],
        result: m['result'],
        direction: m['direction'],
        weights: weights_for(m['result'], m['direction']),
      } 
    end
  }
}.sort_by { |p| p[:id] }

puts JSON.pretty_generate(policies)



  

