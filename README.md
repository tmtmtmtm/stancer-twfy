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

2. Produce a suitable ``issues.json`` file (see for example, [voteit-data-pw](https://github.com/tmtmtmtm/voteit-data-pw))

3. ``ruby bin/generate_stances.rb``

