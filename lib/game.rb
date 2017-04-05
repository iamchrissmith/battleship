require 'pry'
require "colorize"
require './lib/display'
require './lib/board'
require './lib/ai'
require './lib/human'

class Game
  include Display

  def initialize
    @moves = {}
    @start_time = Time.new
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
    clear_screen
    # Ask how hard in the future (Beginner: size = 4 ships = 2)
    difficulty = 4
    num_ships = 2
    human = Human.new("Human")
    computer = AI.new("AI")
    players = [human, computer]
    players.reverse.each do |player|
      @moves[player.name] = 0
      player.board = Board.new(difficulty)
      player.board.build_board
      player.before_ship_placement_message
      sleep 0.5
      ship_placement(player, num_ships)
      sleep 0.5
      player.after_ship_placement_message
      sleep 0.5
      clear_screen
    end
    play_game(players)
  end

  def ship_placement(player, num_ships)
    player.generate_ships(num_ships)
  end

  def notify_all_sunk(players)
    players.any? do |player|
      player.board.all_sunk?
    end
  end

  def play_game(players)
    render_grids(players)
    winner = find_winner(players)
    end_game_sequence(players, winner)
  end

  def find_winner(players)
    loop do
      players.each.with_index do |player, index|
        target = players[1] if index == 0
        target = players[0] if index == 1
        shot = player.shoot(target)
        @moves[player.name] += 1
        puts "Move #{@moves[player.name]} :: #{player.name} : #{shot[0]} : Hit? #{shot[1]} | @ #{target.name}"
        render_grids(players)
        sleep 1
        if notify_all_sunk(players)
          return player
        end
      end
    end
  end

  def end_game_sequence(players, winner)
    end_time = Time.new
    minutes = "#{((end_time - @start_time) / 60).to_i} min"
    seconds = " and #{((end_time - @start_time) % 60).to_i} sec"
    render_grids(players)
    puts "#{winner.name} won the game in #{@moves[winner.name]} moves and #{minutes} #{seconds}."
    exit
  end
end
