require 'spec_helper'

describe Human do

  subject { Human.new("Test") }

  before {subject.board = Board.new(4); subject.board.build_board}

  describe ".initialize" do
    context "when the Human is created" do
      it "has a #name" do
        expect(subject.name).to eq "Test"
      end
      it "is a Human" do
        expect(subject.class).to be Human
      end
      it "is a Player" do
        expect(described_class).to be < Player
      end
    end
  end

  describe ".validate_location" do
    context "compares location to board" do
      it "should report true" do
        expect(subject.validate_location("A1")).to be true # A1
        expect(subject.validate_location("a1")).to be true # a1
        expect(subject.validate_location("B2")).to be true # B2
        expect(subject.validate_location("C3")).to be true # C3
        expect(subject.validate_location("D4")).to be true # D4
      end
      it "should raise error for invalid entries" do
        expect{subject.validate_location("E1")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("A5")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("A0")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("0A")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("E1")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("A!")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("E1")}.to raise_error(InvalidLocation)
        expect{subject.validate_location("A5")}.to raise_error(InvalidLocation)
      end
    end
  end

  describe ".location_occupied?" do
    before { subject.send_ship([["A","1"], ["A","2"]]) }
    context "checking if square is already occupied" do
      it "reports falsey for occupation" do
        expect(subject.location_not_occupied?("A1")).to be_falsey
      end
      it "reports truthy for vacancy" do
        expect(subject.location_not_occupied?("B1")).to be_truthy
      end
    end
  end

  describe ".get_locations" do
    context "receives input from user" do
      it "keeps asking until it receives valid ship placement" do
        allow($stdin).to receive(:gets).and_return('A5 A6')
        expect{subject.get_locations(2)}.to raise_error(InvalidLocation) # Out of Range Number
        allow($stdin).to receive(:gets).and_return('E1 D1')
        expect{subject.get_locations(2)}.to raise_error(InvalidLocation) # Out of Range Letter
        allow($stdin).to receive(:gets).and_return('A! A2')
        expect{subject.get_locations(2)}.to raise_error(InvalidLocation) # Punctuation
        allow($stdin).to receive(:gets).and_return('A1 A3')
        expect{subject.get_locations(2)}.to raise_error(InvalidLocation) # Not connected
        allow($stdin).to receive(:gets).and_return('A2 A1')
        expect{subject.get_locations(2)}.to raise_error(InvalidLocation) # Out of order
        allow($stdin).to receive(:gets).and_return('A1 A2')
        expect(subject.get_locations(2)).to be == [["A", "1"], ["A", "2"]]
      end
    end
  end

  describe ".coordinates_sequential?" do
    context "check if coordinates are sequetial" do
      it "returns true if in order" do
        expect(subject.coordinates_sequential?(["A1","A2","A3"])).to be true
        expect(subject.coordinates_sequential?(["B1","C1"])).to be true
      end
      it "returns false if out of order" do
        expect(subject.coordinates_sequential?(["A2","A1"])).to be false
        expect(subject.coordinates_sequential?(["A1","A3"])).to be false
        expect(subject.coordinates_sequential?(["D1","D2","A1"])).to be false
      end
    end
  end

  describe ".validate_group" do
    context "make sure coordinates work together" do
      it "reports valid for adjoining coordinates" do
        expect(subject.validate_group(["A1", "A2"],2)).to be true
        expect(subject.validate_group(["A1", "B1"],2)).to be true
      end
      it "reports invalid for not connected" do
        expect{subject.validate_group(["A1", "A3"],2)}.to raise_error(InvalidLocation)
        expect{subject.validate_group(["A1", "C1"],2)}.to raise_error(InvalidLocation)
      end
      it "reports invalid for out of order" do
        expect{subject.validate_group(["A2", "A1"],2)}.to raise_error(InvalidLocation)
        expect{subject.validate_group(["B1", "A1"],2)}.to raise_error(InvalidLocation)
      end
      it "reports invalid for too short" do
        expect{subject.validate_group(["A2"],2)}.to raise_error(InvalidLocation)
      end
      it "reports invalid for too long" do
        expect{subject.validate_group(["A1", "A2", "A3"],2)}.to raise_error(InvalidLocation)
      end
    end
  end

  describe ".validate_each_coordinate" do
    context "make sure each coordinate is valid independently" do
      it "reports valid for A1 A2" do
        expect(subject.validate_each_coordinate(["A1","A2"])).to be true
      end
      it "reports invalid for A5 A2 and A2 A5" do
        expect{subject.validate_each_coordinate(["A5","A2"])}.to raise_error(InvalidLocation)
        expect{subject.validate_each_coordinate(["A2","A5"])}.to raise_error(InvalidLocation)
      end
    end
  end
end
