require './lib/validate_module'
require './lib/messages_validate_module'
require 'forwardable'

class Player
  extend Forwardable
  include Validate
  include ValidateMessages

  attr_reader :name
  attr_accessor :board
  def_delegator :@board, :build_board
  def_delegator :@board, :all_sunk?
  def_delegator :@board, :split_location
  def_delegator :@board, :translate_location
  def_delegator :@board, :letter_rows, :our_rows
  def_delegator :@board, :letter_to_number
  def_delegator :@board, :place_ship, :send_ship

  def initialize(name)
    @name = name
    @board = nil
  end

  def before_ship_placement_message; end

  def after_ship_placement_message; end

  def get_locations(length)
    raise NotImplementedError
  end

  def shoot(target)
    results = {}
    results[:where] = get_target(target)
    square = target.translate_location(results[:where])
    results[:success?] = square.hit?
    results[:sunk?] = square.ship.sunk? if results[:success?]
    results[:ship_length] = square.ship.length if results[:sunk?]
    results
  end

  def generate_ships(number)
    length = 2
    number.times do
      locations = get_locations(length)
      send_ship(locations)
      length += 1
    end
  end
end
