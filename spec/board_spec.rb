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

  describe "build_board" do
    context "sets up the board" do
      it "sets the root and it is a Square" do
        expect(subject.root.class).to eq(Square)
      end
    end
  end

  describe "jump_to_square" do
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

  describe "place_ship" do
    before {@new_ship = subject.place_ship(["A1", "A2"])}
    context "need to place a ship on the board" do
      it "creates the ship" do
        expect(subject.ships[0]).to eq(@new_ship)
        expect(subject.ships[0].class).to eq(Ship)
      end
      it "assigns the squares to the ship" do
        expect(subject.ships[0].squares[0].row).to eq(0)
        expect(subject.ships[0].squares[0].column).to eq(0)
        expect(subject.ships[0].squares[1].row).to eq(0)
        expect(subject.ships[0].squares[1].column).to eq(1)
      end
      it "assigns the ship to the squares" do
        expect(subject.jump_to_square(0,0).ship).to eq(@new_ship)
        expect(subject.jump_to_square(0,1).ship).to eq(@new_ship)
      end
    end

  end
end
