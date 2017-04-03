require 'spec_helper'
require "./lib/square"

describe Square do

  class DummyShip
    attr_accessor :hits
    def initialize
      @hits = 0
    end
  end

  subject { Square.new(0,0) }

  describe "initialize" do
    context "when the square is created" do
      it "it has a row and column" do
        expect(subject.class).to eq(Square)
        expect(subject.row).to eq(0)
        expect(subject.column).to eq(0)
      end
    end
  end

  before {
    @s_0_1 = Square.new(0,1)
    @s_0_2 = Square.new(0,2)

    @s_1_0 = Square.new(1,0)
    @s_1_1 = Square.new(1,1)
    @s_1_2 = Square.new(1,2)

    @s_2_0 = Square.new(2,0)
    @s_2_1 = Square.new(2,1)
    @s_2_2 = Square.new(2,2)
    # (0,0)
    subject.neighbors[:right] = @s_0_1
    subject.neighbors[:below] = @s_0_1
    # (0,1)
    @s_0_1.neighbors[:left] = subject
    @s_0_1.neighbors[:right] = @s_0_2
    @s_0_1.neighbors[:below] = @s_1_1
    # (0,2)
    @s_0_2.neighbors[:left] = @s_0_1
    @s_0_2.neighbors[:below] = @s_1_2
    # (1,0)
    @s_1_0.neighbors[:above] = subject
    @s_1_0.neighbors[:right] = @s_1_1
    @s_1_0.neighbors[:below] = @s_2_0
    # (1,1)
    @s_1_1.neighbors[:above] = @s_0_1
    @s_1_1.neighbors[:left] = @s_1_0
    @s_1_1.neighbors[:right] = @s_1_2
    @s_1_1.neighbors[:below] = @s_2_1
    # (1,2)
    @s_1_2.neighbors[:above] = @s_0_2
    @s_1_2.neighbors[:left] = @s_1_1
    @s_1_2.neighbors[:below] = @s_2_2
    # (2,0)
    @s_2_0.neighbors[:above] = @s_1_0
    @s_2_0.neighbors[:right] = @s_2_1
    # (2,1)
    @s_2_1.neighbors[:above] = @s_1_1
    @s_2_1.neighbors[:left] = @s_2_1
    @s_2_1.neighbors[:right] = @s_2_2
    # (2,2)
    @s_2_2.neighbors[:above] = @s_1_2
    @s_2_2.neighbors[:left] = @s_2_1
  }

  describe ".find_square" do
    context "we can find a square from another square" do
      it "can move right" do
        expect(subject.find_square(0,2)).to eq(@s_0_2)
        expect(subject.find_square(0,2).row).to eq(0)
        expect(subject.find_square(0,2).column).to eq(2)
      end
      it "can move down" do
        expect(subject.find_square(1,1)).to eq(@s_1_1)
        expect(subject.find_square(1,1).row).to eq(1)
        expect(subject.find_square(1,1).column).to eq(1)
      end
      it "can move all the way across" do
        expect(subject.find_square(2,2)).to eq(@s_2_2)
        expect(subject.find_square(2,2).row).to eq(2)
        expect(subject.find_square(2,2).column).to eq(2)
      end
      it "can move from the end back to the beginning" do
        expect(@s_2_2.find_square(0,0)).to eq(subject)
        expect(@s_2_2.find_square(0,0).row).to eq(0)
        expect(@s_2_2.find_square(0,0).column).to eq(0)
      end
      it "when invalid coordinates are entered, they return nil" do
        expect(subject.find_square(4,4)).to be_nil
      end
    end
  end

  describe ".hit?" do
    context "schrodinger's square" do
      it "is neither hit or missed before asked" do
        expect(subject.status).to be_nil
      end
    end
    context "when there is no ship" do
      it "reports a miss" do
        expect(subject.ship).to be_nil
        expect(subject.hit?).to be false
      end
    end
    context "when there is a ship" do
      before {subject.ship = DummyShip.new}
      it "reports a hit" do
        expect(subject.hit?).to be true
        expect(subject.ship.hits).to be(1)
      end
    end
  end

  describe "add_ship" do
    context "a square can hold a ship" do
      it "returns the ships location" do

      end
      it "assigns itself and neighbors to ship's location" do
      end
    end
  end

end
