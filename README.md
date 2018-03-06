LQD-STOCK
=========

Fetch & Display stock information

Currently, the project depends on [Quandl](https://www.quandl.com/)'s API.

## Purpose

This projects allows a CLI interface to fetch & display stock information.

The user supplies a stock sign and a date, and the application retreives information about the stock starting the specified date.

The application calculates and displays:
- The Return, starting the specified date till today.
- The Maximum Drawdown for this stock during this time period.

The project supports the following methods for **publishing** the information:
1. Via a simple console output
1. By Email
1. Via a Twitter status
1. By a [designated page](http://lqd-stock.ma-kaf.com)

## Prerequisites
1. Ruby 2.5.0
1. Bundler

## Install & Setup
1. Checkout the project: `$ git clone http://github.com/dancar/lqd-stock`
1. install gems: `cd lqd-stock && bundle`
1. Provide configuration file `settings.yml`
  -  To this end, a self-explanatory **example** configuration file settings `settings.yml.example` is provided.
  -  Note that in for the different publishing methods to work, all settings must be valid and enabled.
  -  A Quandl API key must be provided as well.

## Usage

Usage:
`$ ruby bin/get_stock_info.rb [STOCK] [DATE]`

Date Format: `yyyy-mm-dd`

Example:

`$ ruby bin/get_stock_info.rb FB 2018-02-25`

## Testing
```
$ bundle exec rspec
```
