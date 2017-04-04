require 'spec_helper'


describe Ship do

  subject { Ship.new(2) }

  describe ".initialize" do
    context "when a new ship is created" do
      it "is a ship" do
        expect(subject.class).to eq(Ship)
      end
      it "has zero hits" do
        expect(subject.life).to eq(2)
      end
    end
  end

  describe ".sunk?" do
    context "when a ship gets hit" do
      it "knows if it is sunk" do
        subject.life -= 1
        expect(subject.life).to eq(1)
        expect(subject.sunk?).to be false
        subject.life -= 1
        expect(subject.life).to eq(0)
        expect(subject.sunk?).to be true
      end
    end
  end

  describe "#life" do
    it "knows its #life" do
      expect(subject.life).to be 2
    end
  end

end
