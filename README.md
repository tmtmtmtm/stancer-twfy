# Stancer-PW

## Summary

Generate Voting Stances suitable for TheyWorkForYou.com

## Background

[Stancer](https://github.com/tmtmtmtm/stancer) allows you
generate the 'stances' taken by a politician, or group of politicians,
on an Issue.

This is the specific implementation of that for UK voting data.

## Status

This is a work in progress. Both the input and output formats will
change.

## Usage

1. Install 'stancer' from https://github.com/tmtmtmtm/stancer

1. Generate ``motions`` and ``issues`` source data. We currently get
these from the Morph.io pseudo-API to PublicWhip.org.uk

    1. ``MORPH_API_KEY=yourkey ruby bin/make_popolo_json.rb > tmp/motions.json``

    1. ``MORPH_API_KEY=yourkey ruby bin/make_issues_json.rb > tmp/issues.json``

1. ``ruby bin/generate_stances.rb > tmp/stances.json``

