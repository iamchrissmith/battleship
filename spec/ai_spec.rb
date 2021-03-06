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

  describe "shooting" do
    before do
      @human = Human.new("FiringDummy")
      @human.board = Board.new(4);
      @human.build_board
    end
    describe ".get_target" do
      context "AI generates valid firing positions" do
        it "should be between A and D and 1 and 4" do
          100.times do
            expect(["A","B","C","D"]).to include(subject.get_target(@human)[0])
            expect(["1","2","3","4"]).to include(subject.get_target(@human)[1])
          end
        end
        before {@human.translate_location("A1").hit?}
        it "should not already be fired at" do
          100.times do
            expect(subject.get_target(@human)).not_to eq("A1")
          end
        end
      end
    end
    describe ".shoot" do
      context "AI returns proper results for a shot" do
        it "should have a valid :where" do
          expect(["A","B","C","D"]).to include(subject.shoot(@human)[:where][0])
          expect(["1","2","3","4"]).to include(subject.shoot(@human)[:where][1])
        end
        it "should not report :success if no hit" do
          expect(subject.shoot(@human)[:success?]).to be false
        end
      end
    end
  end

  describe ".get_locations" do
    context "in AI" do
      it "should generate random locations" do
        expect(subject.get_locations(2).class).to eq Array
      end
      it "should be the right length" do
        expect(subject.get_locations(2).length).to be 2
      end
      it "should be an array of strings" do
        locations = subject.get_locations(2)
        locations.each do |location|
          expect(location.class).to eq String
          expect(location.length).to be 2
        end
      end
    end
  end

  describe ".valid_directions" do
    context "AI must have valid ship alignment" do
      it "returns valid directions for A1" do
        expect(subject.valid_directions(2, "A1")).to include("below")
        expect(subject.valid_directions(2, "A1")).to include("right")
        expect(subject.valid_directions(2, "A1")).not_to include("above")
        expect(subject.valid_directions(2, "A1")).not_to include("left")
      end
      it "returns valid directions for D4" do
        expect(subject.valid_directions(2, "D4")).to include("above")
        expect(subject.valid_directions(2, "D4")).to include("left")
        expect(subject.valid_directions(2, "D4")).not_to include("below")
        expect(subject.valid_directions(2, "D4")).not_to include("right")
      end
      it "returns valid directions for B2" do
        expect(subject.valid_directions(2, "B2")).to include("above")
        expect(subject.valid_directions(2, "B2")).to include("left")
        expect(subject.valid_directions(2, "B2")).to include("below")
        expect(subject.valid_directions(2, "B2")).to include("right")
      end
    end
    context "AI ships cannot overlap" do
      before do
        subject.board.place_ship(["B1","B2","B3","B4"])
        subject.board.place_ship(["C2","D2"])
      end
      it "will not find overlapping horizontal locations" do
        expect(subject.valid_directions(2, "C1")).not_to include("above")
        expect(subject.valid_directions(2, "C1")).not_to include("right")
        expect(subject.valid_directions(2, "D3")).not_to include("left")
        expect(subject.valid_directions(2, "A2")).not_to include("below")
      end
    end
  end

  describe ".populate_locations" do
    context "gets sequential locations in the right direction" do
      it "returns the next valid location" do
        locations = ["A1"]
        expect(subject.populate_locations("A1","right",2,locations)).to eq ["A1", "A2"]
        locations = ["A1"]
        expect(subject.populate_locations("A1","below",2, locations)).to eq ["A1", "B1"]
        locations = ["A2"]
        expect(subject.populate_locations("A2","left",2, locations)).to eq ["A2", "A1"]
        locations = ["B1"]
        expect(subject.populate_locations("B1","above",2, locations)).to eq ["B1", "A1"]
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

  describe ".sort_found_locations" do
    it "sorts an array properly" do
      expect(subject.sort_found_locations(["A1", "A2", "A3"])).to eq ["A1", "A2", "A3"]
      expect(subject.sort_found_locations(["A3", "A2", "A1"])).to eq ["A1", "A2", "A3"]
      expect(subject.sort_found_locations(["A2", "A1", "A3"])).to eq ["A1", "A2", "A3"]

      expect(subject.sort_found_locations(["B1", "B2", "B3"])).to eq ["B1", "B2", "B3"]
      expect(subject.sort_found_locations(["B3", "B2", "B1"])).to eq ["B1", "B2", "B3"]
      expect(subject.sort_found_locations(["B2", "B1", "B3"])).to eq ["B1", "B2", "B3"]

      expect(subject.sort_found_locations(["A1", "B2", "C3"])).to eq ["A1", "B2", "C3"]
      expect(subject.sort_found_locations(["A3", "B2", "C1"])).to eq ["A3", "B2", "C1"]
      expect(subject.sort_found_locations(["D2", "C1", "A3"])).to eq ["A3", "C1", "D2"]
    end
  end

  describe ".shot_message" do
    it "returns hit message when passed true" do
      expect{subject.shot_message(true)}.to output("Oh no! The computer hit you!\n").to_stdout
    end
    it "returns miss message when passed true" do
      expect{subject.shot_message(false)}.to output("Phew! It missed\n").to_stdout
    end
  end

  describe ".sunk_message" do
    it "returns message with proper ship length" do
      expect{subject.sunk_message(2)}.to output("Look out the computer sunk your two-unit ship!\n").to_stdout
    end
    it "returns message with proper ship length" do
      expect{subject.sunk_message(3)}.to output("Look out the computer sunk your three-unit ship!\n").to_stdout
    end
  end
end
