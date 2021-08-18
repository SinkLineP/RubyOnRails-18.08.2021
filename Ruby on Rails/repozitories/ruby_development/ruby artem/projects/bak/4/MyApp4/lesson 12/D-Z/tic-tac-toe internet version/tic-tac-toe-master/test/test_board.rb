require_relative '../src/board'
require 'test/unit'

class TestBoard < Test::Unit::TestCase
  def test_board_spots
    assert_equal(['0', '1', '2', '3', '4', '5', '6', '7', '8'], Board.new.spots)
  end

  def test_board_choose_spot
    board = Board.new
    assert_equal('2', board.spots[2])
    board.choose_spot(2, 'X')
    assert_equal('X', board.spots[2])
  end

  def test_game_over
    board = Board.new
    assert_equal(board.game_over?, false)
    board.choose_spot(0, 'X')
    board.choose_spot(1, 'X')
    board.choose_spot(2, 'X')
    assert_equal(board.game_over?, true)
  end

  def test_tie
    board = Board.new
    assert_equal(board.tie?, false)
    print_all_board_to_tie(board)
    assert_equal(board.tie?, true)
  end

  private

  def print_all_board_to_tie(board)
    board.choose_spot(0, 'X')
    board.choose_spot(1, 'O')
    board.choose_spot(2, 'X')
    board.choose_spot(3, 'O')
    board.choose_spot(4, 'X')
    board.choose_spot(5, 'O')
    board.choose_spot(6, 'X')
    board.choose_spot(7, 'O')
    board.choose_spot(8, 'X')
  end
end
