require 'spec_helper'

describe AI do

  subject { AI.new("Test") }

  before {subject.board = Board.new(4); subject.build_board}

  describe ".initialize" do
    context "when the AI is created" do
      it "has a #name" do
        expect(subject.name).to eq "Test"
      end
      it "is an AI" do
        expect(subject.class).to be AI
      end
      it "is a Player" do
        expect(described_class).to be < Player
      end
    end
  end

  describe ".get_first_location" do
    context "AI generates valid starting points" do
      it "should be between A and D and 1 and 4" do
        100.times do
          expect(["A","B","C","D"]).to include(subject.get_first_location[0])
          expect(["1","2","3","4"]).to include(subject.get_first_location[1])
        end
      end
      before {subject.translate_location("A1").ship = Ship.new(1)}
      it "should not already be occupied" do
        100.times do
          expect(subject.get_first_location).not_to eq(["A","1"])
        end
      end
    end
  end

  describe ".get_locations" do
    context "in AI" do
      it "should generate random locations" do
        expect(subject.get_locations(2).class).to be Array
      end
      it "should be the right length" do
        expect(subject.get_locations(2).length).to be 2
      end
      it "should be an array of arrays" do
        locations = subject.get_locations(2)
        locations.each do |location|
          expect(location.class).to be Array
          expect(location.length).to be 2
        end
      end
    end
  end

  describe ".valid_directions" do
    context "AI must have valid ship alignment" do
      it "returns valid directions for A1" do
        expect(subject.valid_directions(2, ["A","1"])).to include("down")
        expect(subject.valid_directions(2, ["A","1"])).to include("right")
        expect(subject.valid_directions(2, ["A","1"])).not_to include("up")
        expect(subject.valid_directions(2, ["A","1"])).not_to include("left")
      end
      it "returns valid directions for D4" do
        expect(subject.valid_directions(2, ["D","4"])).to include("up")
        expect(subject.valid_directions(2, ["D","4"])).to include("left")
        expect(subject.valid_directions(2, ["D","4"])).not_to include("down")
        expect(subject.valid_directions(2, ["D","4"])).not_to include("right")
      end
      it "returns valid directions for B2" do
        expect(subject.valid_directions(2, ["B","2"])).to include("up")
        expect(subject.valid_directions(2, ["B","2"])).to include("left")
        expect(subject.valid_directions(2, ["B","2"])).to include("down")
        expect(subject.valid_directions(2, ["B","2"])).to include("right")
      end
    end
    context "AI ships cannot overlap" do
      before do
        subject.board.place_ship(["B1","B2","B3","B4"])
        subject.board.place_ship(["C2","D2"])
      end
      it "will not find overlapping horizontal locations" do
        expect(subject.valid_directions(2, ["C","1"])).not_to include("up")
        expect(subject.valid_directions(2, ["C","1"])).not_to include("right")
        expect(subject.valid_directions(2, ["D","3"])).not_to include("left")
        expect(subject.valid_directions(2, ["A","2"])).not_to include("down")
      end
    end
  end

  describe ".populate_locations" do
    context "gets sequential locations in the right direction" do
      it "returns the next valid location" do
        locations = [["A","1"]]
        expect(subject.populate_locations(["A","1"],"right",2,locations)).to eq [["A","1"], ["A","2"]]
        locations = [["A","1"]]
        expect(subject.populate_locations(["A","1"],"down",2, locations)).to eq [["A","1"], ["B","1"]]
        locations = [["A","2"]]
        expect(subject.populate_locations(["A","2"],"left",2, locations)).to eq [["A","2"], ["A","1"]]
        locations = [["B","1"]]
        expect(subject.populate_locations(["B","1"],"up",2, locations)).to eq [["B","1"], ["A","1"]]
      end
    end
  end

  describe ".generate_ships" do
    before {subject.generate_ships(2)}
    context "AI can generate and place ships" do
      it "assigns ships to board" do
        expect(subject.board.ships.length).to be 2
        expect(subject.board.ships[0].life).to be 2
        expect(subject.board.ships[1].life).to be 3
      end
    end
  end
end
