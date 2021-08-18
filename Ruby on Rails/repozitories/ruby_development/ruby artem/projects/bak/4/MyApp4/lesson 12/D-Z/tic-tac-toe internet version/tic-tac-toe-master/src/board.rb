require_relative '../lib/board_spot_management'

class Board
  include BoardSpotManagement

  attr_reader :spots

  def initialize
    @spots = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
  end

  def choose_spot(index, mark)
    spots[index] = mark
  end
end
