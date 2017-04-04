require 'pry'
require "colorize"
require './lib/display'
require './lib/board'
require './lib/ai'
require './lib/human'

class Game
  include Display
  # Start times
  # Moves

  def run
    clear_screen
    puts welcome_message
    cmd = get_user_input
    case cmd
    when "p" then start_game
    when "i" then display_instructions
    when "q" then quit_game
    else
      puts "Invalid Command".red.bold
      sleep 0.5
      run
    end
  end

  def quit_game
    clear_screen
    puts "Goodbye, Dave!".light_red.bold
    sleep 0.75
    clear_screen
    exit
  end

  def start_game
    # Ask how hard in the future (Beginner: size = 4 ships = 2)
    difficulty = 4
    num_ships = 2
    human = Human.new("Human")
    computer = AI.new("AI")
    players = [computer, human]
    players.each do |player|
      player.board = Board.new(difficulty)
      player.board.build_board
      player.before_ship_placement_message
      ship_placement(player, num_ships)
      player.after_ship_placement_message
    end
  end

  def ship_placement(player, num_ships)
    clear_screen
    player.generate_ships(num_ships)
  end
end
