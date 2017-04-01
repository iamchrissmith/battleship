require 'pry'
require "colorize"
require './lib/display'

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
  end
end
