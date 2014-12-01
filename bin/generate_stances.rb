#!/usr/bin/ruby

require 'json'
require 'stancer'

stancer = Stancer.new(
  sources: { 
    issues:  'https://raw.githubusercontent.com/tmtmtmtm/stance-viewer-sinatra/8cb8879092a211ffa3f2626c7e97aaea8897f730/data/issues.json', #FIXME
    motions: 'tmp/motions.json',
  }
)

stances = stancer.all_stances(group_by: 'group', exclude: 'indicators')
puts JSON.pretty_generate(stances)
