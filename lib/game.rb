require 'pry'
require "colorize"
require './lib/display'
require './lib/board'

class Game
  include Display

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
    # Ask how hard in the future
    difficulty = 4
    player = Player.new("Human")
    player.board = Board.new(difficulty)
    player.board.build_board
    computer = AI.new("AI")
    computer.board = Board.new(difficulty)
    computer.board.build_board
    ship_placement(player, computer)
    # root = board.jump_to_square(1,1)
    # root_row = root.row
    # root_column = root.column
    # left = root.neighbors[:left]
    # left_row = left.row
    # left_column = left.column
    # right = root.neighbors[:right]
    # right_row = right.row
    # right_column = right.column
    # above = root.neighbors[:above]
    # above_row = above.row
    # above_column = above.column
    # below = root.neighbors[:below]
    # below_row = below.row
    # below_column = below.column
    # puts "Root: #{root_row}, #{root_column}"
    # puts "Left: #{left_row}, #{left_column}"
    # puts "Right: #{right_row}, #{right_column}"
    # puts "Above: #{above_row}, #{above_column}"
    # puts "Below: #{below_row}, #{below_column}"
  end
end
