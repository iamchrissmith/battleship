class InvalidLocation < StandardError
  attr_reader :location
  def initialize(msg="You must enter a location on the board. You entered: ", location)
    @location = location
    msg = msg + " You entered: " + location
    super(msg)
  end
end
