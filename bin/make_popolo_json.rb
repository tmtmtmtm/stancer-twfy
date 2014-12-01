#!/usr/bin/ruby

# Convert PublicWhip vote data (fetched over the Morph.io API) 
# into Popolo Vote format

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


SQL_POLICIES = 'SELECT * FROM data WHERE policy IN (363, 811)'
SQL_POLICY_VOTES = 'SELECT * FROM votes v LEFT JOIN voters mp ON v.url = mp.url WHERE motion = "%s"'

raw = morph_select(SQL_POLICIES)
divisions = JSON.parse(raw)

popolo = divisions.map do |div|
  warn "#{div['id']} = #{div['text']}".cyan
  raw_votes = morph_select(SQL_POLICY_VOTES % div['id'])
  votes = JSON.parse(raw_votes)

  motion = {
    id: div['id'],
    organization_id: 'uk.parliament.commons',
    text: div['text'],
    date: div['date'],
    result: div['result'],
    vote_events: [
      start_date: div['datetime'],
      # counts: [], # TODO
      votes: votes.map { |v|
        {
          voter: { 
            name: v['name'],
            constituency: v['constituency'],
            id: v['id'],
          },
          option: v['option'],
          group_id: v['party'].downcase,
        }
      }
    ]
  }

end

puts JSON.pretty_generate(popolo)



  

