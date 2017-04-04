require 'spec_helper'

describe Display do

  class DummyGame
    include Display
  end

  subject { DummyGame.new }

  describe ".welcome_message" do
    context "when the player first runs the program" do
      it "displays welcome message" do
        message = "Welcome to BATTLESHIP".blue.bold.underline
        message += "\n\nWould you like to "
        message += "(p)".green
        message += "lay, read the "
        message += "(i)".yellow
        message += "nstructions, or "
        message += "(q)".red
        message += "uit?\n"
        message
        expect(subject.welcome_message).to eq(message)
      end
    end
  end

  describe ".get_instructions" do
    context "when the player enters 'i' from the main screen" do
      it "returns instructions from file" do
        expected = File.read('./lib/instructions.txt')
        expect(subject.get_instructions).to eq(expected)
      end
    end
  end

  describe '.capture_user_input' do
    context "ask for the user's input" do
      it "should return user input command" do
        allow($stdin).to receive(:gets).and_return('i')
        expect(subject.get_user_input).to eq 'i'
        allow($stdin).to receive(:gets).and_return('p')
        expect(subject.get_user_input).to eq 'p'
        allow($stdin).to receive(:gets).and_return('q')
        expect(subject.get_user_input).to eq 'q'
      end
    end
  end

  describe ".board_columns" do
    context "render column labels" do
      it "should output appropriate length for column headers" do
        expect(subject.board_columns(2)).to eq(" *  1  2 ")
        expect(subject.board_columns(4)).to eq(" *  1  2  3  4  ")
      end
    end
  end

  describe ".board_boundary" do
    context "render === boundary" do
      it "should output appropriate length for boundary" do
        expect(subject.board_boundary(2)).to eq("========")
        expect(subject.board_boundary(4)).to eq("================")
      end
    end
  end

  describe ".board_owner" do
    before {@owner = Human.new("Human")}
    context "display board owner" do
      it "should output owner centered" do
        expect(subject.board_owner(@owner.name, 2)).to eq(" Human  ")
        expect(subject.board_owner(@owner.name, 4)).to eq("     Human      ")
      end
    end
  end

  describe ".get_board_row" do
    before do
      @owner = Human.new("Human")
      @owner.board = Board.new(4)
      @owner.board.build_board
    end
    context "display initial board row" do
      it "should output empty row" do
        expect(subject.get_board_row(0, @owner)).to eq(" 0             ")
      end
    end
    context ".get_shot_square" do
      before do
        @hit_square = @owner.board.jump_to_square(0,0)
        @hit_square.ship = Ship.new([@hit_square])
        @hit_square.hit?
      end
      it "should return H" do
        expect(subject.get_shot_square(@hit_square)).to eq("\e[0;39;41m H \e[0m")
      end
      before do
        @miss_square = @owner.board.jump_to_square(0,1)
        @miss_square.hit?
      end
      it "should return M" do
        expect(subject.get_shot_square(@miss_square)).to eq(" M ")
      end
    end
    context ".get_empty_square" do
      it "should return '  '" do
        expect(subject.get_empty_square(@owner.board.jump_to_square(1,1), @owner)).to eq ("   ")
      end
    end
  end

end
