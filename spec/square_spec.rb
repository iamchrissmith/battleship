require 'spec_helper'
require "./lib/square"

describe Square do

  subject { Square.new(0,0) }

  before {
    @s_0_1 = Square.new(0,1)
    @s_1_1 = Square.new(1,1)
    @s_1_2 = Square.new(1,2)
    @s_2_2 = Square.new(2,2)
  }

  skip describe ".board initialize" do
    context "when the board is created" do
      it "it has a size and squares" do
        expect(subject.class).to eq(Board)
        expect(subject.size).to eq(4)
        expect(subject.root.class).to eq(Square)
      end
    end
  end

  skip describe ".find_square" do
    context "we can find a square from another square" do
      it "when coordinates are entered, they return the right square" do
        expect(subject.find_square(1,1)).to eq(@s_1_1)
        expect(subject.find_square(1,1).row).to eq(1)
        expect(subject.find_square(1,1).column).to eq(1)
        expect(subject.find_square(2,2)).to eq(@s_2_2)
        expect(subject.find_square(2,2).row).to eq(2)
        expect(subject.find_square(2,2).column).to eq(2)
      end
      it "when invalid coordinates are entered, they return nil" do
        expect(subject.find_square(4,4)).to be_nil
      end
    end
  end

end
