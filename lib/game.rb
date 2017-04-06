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
    board_options = select_difficulty
    make_players
    make_boards(board_options)
    play_game
  end

  def select_difficulty
    puts options_message
    difficulty = get_user_input
    level = validate_options(difficulty)
    num_ships = (level / 4) + 1
    [level, num_ships]
  end

  def validate_options(difficulty)
    return select_difficulty if !["e","m","h"].include?(difficulty)
    difficulties = {
      "e" => 4,
      "m" => 8,
      "h" => 12
    }
    difficulties[difficulty]
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
        result = player.shoot(target)
        @moves[player.name] += 1
        write_to_log(player.name, result)
        render_grids
        if result[:sunk?]
          player.sunk_message(result[:ship_length])
        else
          player.shot_message(result[:success?])
        end
        if notify_all_sunk
          return player
        end
      end
    end
  end

  def write_to_log(name, shot)
    entry = [@moves[name], name, shot[:where], shot[:success?]]
    entry << shot[:sunk?] if shot[:sunk?]
    entry << shot[:ship_length] if shot[:sunk?]
    @log << entry
  end

  def end_game_sequence(winner)
    end_time = Time.new
    minutes = "#{((end_time - @start_time) / 60).to_i} min"
    seconds = " and #{((end_time - @start_time) % 60).to_i} sec"
    render_grids
    winner.victory_message(@moves, minutes, seconds)
    print @log
    exit
  end
end
