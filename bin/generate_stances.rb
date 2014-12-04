#!/usr/bin/ruby

require 'json'
require 'stancer'

# usually 'voter' or 'group'
group_by = ARGV.first || 'group'

stancer = Stancer.new(
  sources: { 
    issues:  'tmp/issues.json',
    motions: 'tmp/motions.json',
  }
)

stances = stancer.all_stances(group_by: group_by, exclude: 'indicators')
puts JSON.pretty_generate(stances)
