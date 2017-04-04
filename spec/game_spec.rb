require 'spec_helper'

describe Game do

  subject { Game.new }
  before { $stdin = StringIO.new }
  after { $stdin = STDIN }

  describe ".run" do
    skip it "should return the command entered" do
      allow($stdin).to receive(:gets).and_return("w\n")
      expect(subject.run).to eq "w"
    end
  end

  describe ".open_screen" do
    skip context "main game start" do
      it "returns invalid command for something other than p, q, i" do
        # allow($stdin).to receive(:gets).and_return("w\n")
        # expect {subject.open_screen}.to output("\e[1;31;49mInvalid Command\e[0m\n").to_stdout
        allow($stdin).to receive(:gets).and_return("q\n")
        expect {subject.open_screen}.to output("\e[1;31;49mGoodbye, Dave!\e[0m\n").to_stdout
        # $stdin.should_receive(:gets).and_return('w')
        # STDOUT.should_receive(:puts).with("string")
        # allow($stdin).to receive(:gets).and_return('w')
        # expect {subject.run}.to output("Invalid Command\n").to_stdout
        # allow($stdin).to receive(:gets).and_return('w')
        # expect {subject.run}.to output("Invalid Command\n").to_stdout
        # allow($stdin).to receive(:gets).and_return("q\n")
        # expect {subject.run}.to output("Goodbye, Dave!\n").to_stdout
      end
    end
  end

end
