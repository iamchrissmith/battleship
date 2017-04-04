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
        expect(subject.get_user_input).to be == 'i'
        allow($stdin).to receive(:gets).and_return('p')
        expect(subject.get_user_input).to be == 'p'
        allow($stdin).to receive(:gets).and_return('q')
        expect(subject.get_user_input).to be == 'q'
      end
    end
  end
end
