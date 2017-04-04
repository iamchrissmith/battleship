require 'spec_helper'


describe Ship do

  class DummyPlayer
  end

  class DummySquare
    attr_reader :row, :column
    def initialize(row,column)
        @row = row
        @column = column
    end
  end

  before do
      @square_1 = DummySquare.new(0,0)
      @square_2 = DummySquare.new(0,1)
  end

  subject { Ship.new([@square_1, @square_2]) }

  describe ".initialize" do
    context "when a new ship is created" do
      it "is a ship" do
        expect(subject.class).to eq(Ship)
      end
      it "has a #length" do
        expect(subject.length).to eq(2)
      end
      it "has zero #hits" do
        expect(subject.hits).to eq(0)
      end
    end
  end

  describe ".sunk?" do
    context "when a ship gets hit" do
      it "knows if it is sunk" do
        subject.hits += 1
        expect(subject.hits).to eq(1)
        expect(subject.sunk?).to be false
        subject.hits += 1
        expect(subject.hits).to eq(2)
        expect(subject.sunk?).to be true
      end
    end
  end

  describe "location" do
    context "a square can be assigned to ship's location" do
      it "knows which #squares it is on" do
        subject.squares.each do |square|
          expect(square.class).to eq(DummySquare)
        end
      end
    end
  end

  describe "#length" do
    it "knows its #length from #squares" do
      expect(subject.length).to be 2
    end
  end

end
