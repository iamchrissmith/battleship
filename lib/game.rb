require 'pry'
require "colorize"
require './lib/display'
require './lib/board'
require './lib/ai'
require './lib/human'


# Refactor to allow A1 to stay A1 instead of changing to 0,0

class Game
  include Display

  def initialize
    @moves = {}
    @start_time = Time.new
    @log = []
    @players = []
  end

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
    else warn_invalid_response(cmd)
    end
  end

  def warn_invalid_response(cmd)
    puts "Invalid Command".red.bold
    cmd
    sleep 0.5
    run
  end

  def quit_game
    clear_screen
    puts "Goodbye, Dave!".light_red.bold
    sleep 0.75
    clear_screen
    exit
  end

  def start_game
    clear_screen
    # Ask how hard in the future (Beginner: size = 4 ships = 2)
    difficulty = 4
    num_ships = 2
    board_options = [difficulty, num_ships]
    make_players
    make_boards(board_options)
    play_game
  end

  def make_players
    @players << Human.new("Human")
    @players << AI.new("AI")
  end

  def make_boards(options)
    @players.reverse.each do |player|
      @moves[player.name] = 0
      player.board = Board.new(options[0])
      player.build_board
      player.before_ship_placement_message
      sleep 0.5
      ship_placement(player, options[1])
      sleep 0.5
      player.after_ship_placement_message
      sleep 0.5
      clear_screen
    end
  end

  def ship_placement(player, num_ships)
    player.generate_ships(num_ships)
  end

  def notify_all_sunk
    @players.any? do |player|
      player.board.all_sunk?
    end
  end

  def play_game
    render_grids
    winner = find_winner
    end_game_sequence(winner)
  end

  def find_winner
    loop do
      @players.each.with_index do |player, index|
        sleep 1
        target = @players.fetch(index + 1, @players[0])
        shot = player.shoot(target)
        @moves[player.name] += 1
        write_to_log(player.name, shot)
        render_grids
        if notify_all_sunk
          return player
        end
      end
    end
  end

  def write_to_log(name, shot)
    @log << [@moves[name], name, shot[0], shot[1]]
  end

  def end_game_sequence(winner)
    end_time = Time.new
    minutes = "#{((end_time - @start_time) / 60).to_i} min"
    seconds = " and #{((end_time - @start_time) % 60).to_i} sec"
    render_grids
    puts "#{winner.name} won the game in #{@moves[winner.name]} moves and #{minutes} #{seconds}."
    print @log
    exit
  end
end
