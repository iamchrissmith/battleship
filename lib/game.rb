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
    open_screen(cmd)
  end

  def open_screen(cmd = '')
    case cmd
    when "p" then start_game
    when "i" then display_instructions
    when "q" then quit_game
    else
      puts "Invalid Command".red.bold
      cmd
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
    players = {
      opponent: computer,
      own: human
    }
    players.each do |k, player|
      player.board = Board.new(difficulty)
      player.board.build_board
      player.before_ship_placement_message
      ship_placement(player, num_ships)
      player.after_ship_placement_message
    end
    play_game(players)
  end

  def ship_placement(player, num_ships)
    clear_screen
    player.generate_ships(num_ships)
  end

  def notify_all_sunk(players)
    return true if players[:opponent].board.all_sunk?
    return true if players[:own].board.all_sunk?
    false
  end

  def play_game(players)
    render_grids(players[:own], players[:opponent])
    one_sunk = false
    until one_sunk
      sleep 0.5
      players.each do |key, player|
        player.shoot
        render_grids(players[:own], players[:opponent])
        if notify_all_sunk(players)
          one_sunk = true
        end
      end
    end
    # if !notify_all_sunk(players)
      # play_game(players)
    # else
    render_grids(players[:own], players[:opponent])
    quit_game
      # end game sequence
    # end
  end
end
