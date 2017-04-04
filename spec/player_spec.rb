require 'spec_helper'

describe Player do

  subject { Player.new("Test") }

  before {subject.board = Board.new(4); subject.board.build_board}

  describe ".initialize" do
    context "when the player is created" do
      it "has a #name" do
        expect(subject.name).to eq("Test")
      end
      it "is a Player" do
        expect(subject.class).to be Player
      end
      it "stores its #board" do
        expect(subject.board.class).to be Board
        expect(subject.board.size).to be 4
      end
    end
  end

  describe ".get_locations" do
    context "in SuperClass" do
      it "should raise error" do
        expect{subject.get_locations(0)}.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".send_ship" do
    context "pass locations" do
      it "should add ship to board" do
        subject.send_ship(["A1","A2"])
        expect(subject.board.ships[0].class).to be(Ship)
        expect(subject.board.ships[0].life).to be(2)
      end
    end
  end

  describe ".shoot" do
    skip context "player firing sequence" do
      it "asks the square if it is hit?" do
        # expect
      end
    end
  end
end
