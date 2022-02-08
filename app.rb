require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch("UM_ENV", ""))

require 'dotenv/load'
require_relative 'lib/um'
