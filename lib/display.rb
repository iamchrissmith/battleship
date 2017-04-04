require 'humanize'

module Display
  def welcome_message
    message = "Welcome to BATTLESHIP".blue.bold.underline
    message += "\n\nWould you like to "
    message += "(p)".green
    message += "lay, read the "
    message += "(i)".yellow
    message += "nstructions, or "
    message += "(q)".red
    message += "uit?\n"
    message
  end

  def get_instructions
    File.read('./lib/instructions.txt')
  end

  def clear_screen
    puts `clear`
  end

  def display_instructions
    clear_screen
    puts get_instructions
    get_user_input
    run
  end

  def get_user_input
    $stdin.gets.chomp
  end
end
