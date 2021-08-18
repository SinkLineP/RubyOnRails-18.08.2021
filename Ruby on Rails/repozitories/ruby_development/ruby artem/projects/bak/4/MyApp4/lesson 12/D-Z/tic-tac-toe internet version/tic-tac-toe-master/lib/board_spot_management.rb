module BoardSpotManagement
  def game_over?
    [board_spots[0], board_spots[1], board_spots[2]].uniq.size == 1 ||
    [board_spots[3], board_spots[4], board_spots[5]].uniq.size == 1 ||
    [board_spots[6], board_spots[7], board_spots[8]].uniq.size == 1 ||
    [board_spots[0], board_spots[3], board_spots[6]].uniq.size == 1 ||
    [board_spots[1], board_spots[4], board_spots[7]].uniq.size == 1 ||
    [board_spots[2], board_spots[5], board_spots[8]].uniq.size == 1 ||
    [board_spots[0], board_spots[4], board_spots[8]].uniq.size == 1 ||
    [board_spots[2], board_spots[4], board_spots[6]].uniq.size == 1
  end

  def tie?
    board_spots.all? { |spot| spot == 'X' || spot == 'O' }
  end

  def chosen_spot?(spot)
    board_spots[spot] == 'X' || board_spots[spot] == 'O'
  end

  def not_chosen_spot?(spot)
    board_spots[spot] != 'X' && board_spots[spot] != 'O'
  end

  def print_current_board_state
    puts " #{board_spots[0]} | #{board_spots[1]} | #{board_spots[2]} \n===+===+===\n #{board_spots[3]} | #{board_spots[4]} | #{board_spots[5]} \n===+===+===\n #{board_spots[6]} | #{board_spots[7]} | #{board_spots[8]} \n\n"
  end

  private

  def board_spots
    spots
  end
end
