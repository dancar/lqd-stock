LQD-STOCK
=========

Fetch & Display stock information

## Purpose

This projects allows a CLI interface to fetch & display stock information.

The user supplies a stock sign and a date, and the application retreives information about it starting that date, calculates and displays:
- The Rate of Return
- The Maximum Drawdown for this stock during this time period.

The project supports the following methods for publishing the information:
- Via a simple console output
- By Email
- Via a Twitter status
- By a designated page: [http://lqd-stock.ma-kaf.com]

## Prerequisites
1. Ruby 2.5.0
1. Bundler

## Install & Setup
1. Checkout the project: `$ git clone http://github.com/dancar/lqd-stock`
1. install gems: `cd lqd-stock && bundle`
1. Provide necessary Secret Keys / Passwords in the local settings file `settings_local.yml`



## Usage

## Testing
'''
bundle exec rspec
'''
