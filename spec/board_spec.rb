require 'spec_helper'

describe Board do

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

  describe ".translate_location" do
    context "when passed human coordinate" do
      it "returns the right square" do
        expect(subject.translate_location("A1").class).to be Square
        expect(subject.translate_location("A1").row).to eq "A"
        expect(subject.translate_location("A1").column).to eq "1"
        expect(subject.translate_location("D4").class).to be Square
        expect(subject.translate_location("D4").row).to eq "D"
        expect(subject.translate_location("D4").column).to eq "4"
      end
    end
  end

  describe ".jump_to_square" do
    context "we can find a square from the board" do
      it "returns the square when coordinates are entered" do
        expect(subject.jump_to_square("A","1").class).to eq(Square)
        expect(subject.jump_to_square("A","1").row).to eq "A"
        expect(subject.jump_to_square("A","1").column).to eq "1"
        expect(subject.jump_to_square("B","3").class).to eq(Square)
        expect(subject.jump_to_square("B","3").row).to eq "B"
        expect(subject.jump_to_square("B","3").column).to eq "3"
      end
      it "returns nil for invalid coordinates" do
        expect(subject.jump_to_square("E","5")).to be_nil
      end
      it "returns the square when starting on right" do
        start = subject.jump_to_square("C","3")
        expect(start.row).to eq("C")
        expect(start.column).to eq("3")
        expect(subject.jump_to_square("A","1",start).class).to eq(Square)
        expect(subject.jump_to_square("A","1",start).row).to eq("A")
        expect(subject.jump_to_square("A","1",start).column).to eq("1")
      end
    end
  end

  describe ".place_ship" do
    before {@new_ship = subject.place_ship(["A1", "A2"])}
    context "need to place a ship on the board" do
      it "creates the ship" do
        expect(subject.ships[0]).to eq(@new_ship)
        expect(subject.ships[0].class).to eq(Ship)
      end
      it "assigns the life to the ship" do
        expect(subject.ships[0].life).to eq(2)
      end
      it "assigns the ship to the squares" do
        expect(subject.jump_to_square("A","1").ship).to eq(@new_ship)
        expect(subject.jump_to_square("A","2").ship).to eq(@new_ship)
      end
    end
  end

  skip describe ".letter_to_number" do
    context "receives a letter" do
      it "returns the index of a valid letter" do
        expect(subject.letter_to_number("A")).to be 0
      end
      it "returns nil if letter off board" do
        expect(subject.letter_to_number("E")).to be nil
      end
    end
  end

  describe "sinking ships" do
    before {
      subject.place_ship(["A1", "A2"])
      subject.place_ship(["B1", "B2"])
    }
    describe ".all_sunk? and #sunk_ships" do
      context "initially no ships are sunk" do
        it "is false when empty and when a ship is still floating" do
          expect(subject.all_sunk?).to be false
          expect(subject.sunk_ships).to eq 0
        end
      end
      context "once all ships are sunk" do
        before {
          subject.ships.each do |ship|
            ship.life = 0
          end
        }
        it "is true when all ships are .sunk?" do
          expect(subject.all_sunk?).to be true
          expect(subject.sunk_ships).to eq 2
        end
      end
    end
  end
end
