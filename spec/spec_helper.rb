require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/test/'
end
require 'pry'
require 'stringio'
require "./lib/game"
require "./lib/display"
require "./lib/board"
require "./lib/square"
require "./lib/ship"
require "./lib/player"
require "./lib/human"
require "./lib/ai"
