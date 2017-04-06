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

  def options_message
    message = "Configure your game".blue.bold.underline
    message += "\n\nWhat level you like to play at\n"
    message += "(e)".green
    message += "asy: 4x4 grid with two ships\n"
    message += "(m)".yellow
    message += "edium: 8x8 grid with three ships\n"
    message += "(h)".red
    message += "ard: 12x12 grid with four ships\n"
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

  def get_user_input(input = gets.chomp)
    input
  end

  def board_boundary(length)
    "====" * length
  end

  def board_owner(owner, length)
    "#{owner}".center(length * 4)
  end

  def board_sunk(board)
    "#{board.sunk_ships}".center(board.size * 4)
  end

  def board_columns(length)
    output = " * "
    length.times do |number|
      output += " #{number + 1} "
    end
    output.center(length * 4)
  end

  def get_empty_square(square, player)
    if !square.ship.nil? && player.is_a?(Human)
      output = "   ".colorize( :background => :white)
    else
      output = "   "
    end
    output
  end

  def get_shot_square(square)
    if square.status == :hit
      output = " H ".colorize( :background => :red)
    elsif square.status == :miss
      output = " M "
    end
    output
  end

  def get_board_row(row, player)
    row_key = ("A".."Z").to_a
    row_letter = row_key[row]
    output = " #{row_key[row]} "
    square = player.board.jump_to_square(row_letter, "1")
    until square.nil?
      if !square.status.nil?
        output += get_shot_square(square)
      else
        output += get_empty_square(square, player)
      end
      square = square.neighbors[:right]
    end
    output
  end

  def render_grids
    own = @players[0]
    opponent = @players[1]
    length = own.board.size
    clear_screen
    puts board_boundary(length) + "\t" + board_boundary(length)
    puts board_owner(own.name, length) + "\t" + board_owner(opponent.name, length)
    puts board_columns(length) + "\t" + board_columns(length)
    length.times do |row|
      puts get_board_row(row, own) + "\t" + "\t" + get_board_row(row, opponent)
    end
    puts board_sunk(own.board) + "\t" + board_sunk(opponent.board)
    puts board_boundary(length) + "\t" + board_boundary(length)
  end
end
