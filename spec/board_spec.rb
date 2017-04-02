require 'spec_helper'
require "./lib/board"

describe Board do

  # before { @board = Board.new(4) }
  subject { Board.new(4) }

  describe "initialize" do
    context "when the board is created" do
      it "is a class of Board and has a size" do
        expect(subject.class).to eq(Board)
        expect(subject.size).to eq(4)
      end
    end
  end

  before { subject.build_board }

  describe ".build_board" do
    context "sets up the board" do
      it "sets the root and it is a Square" do
        expect(subject.root.class).to eq(Square)
      end
    end
  end

  describe ".board_find" do
    context "we can find a square from the board" do
      it "returns the square when coordinates are entered" do
        expect(subject.jump_to_square(0,0).class).to eq(Square)
        expect(subject.jump_to_square(0,0).row).to eq(0)
        expect(subject.jump_to_square(0,0).column).to eq(0)
        expect(subject.jump_to_square(1,2).class).to eq(Square)
        expect(subject.jump_to_square(1,2).row).to eq(1)
        expect(subject.jump_to_square(1,2).column).to eq(2)
      end
      it "returns nil for invalid coordinates" do
        expect(subject.jump_to_square(4,4)).to be_nil
      end
      it "returns the square when starting on right" do
        start = subject.jump_to_square(2,2)
        expect(start.row).to eq(2)
        expect(start.column).to eq(2)
        expect(subject.jump_to_square(0,0,start).class).to eq(Square)
        expect(subject.jump_to_square(0,0,start).row).to eq(0)
        expect(subject.jump_to_square(0,0,start).column).to eq(0)
      end
    end
  end

end
