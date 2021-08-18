class Computer
  attr_reader :mark, :game_level

  def initialize(mark, game_level = :hard)
    @mark = mark
    @game_level = game_level
  end

  def choose_spot(board)
    send("#{game_level}_game", board)
  end

  private

  def easy_game(board)
    available_spots = board.spots.select { |s| s != 'X' && s != 'O' }
    random_number = rand(0..available_spots.count)
    random_spot = available_spots[random_number].to_i

    while board.chosen_spot?(random_spot)
      random_number = rand(0..available_spots.count)
      random_spot = available_spots[random_number].to_i
    end

    board.choose_spot(random_spot, mark)
  end

  def medium_game(board)
    random_number = rand((1..2))
    random_number == 1 ? easy_game(board) : hard_game(board)
  end

  def hard_game(board)
    spot = nil
    until spot
      if board.spots[4] == '4'
        spot = 4
        board.choose_spot(spot, mark)
      else
        spot = get_spot(board)
        if board.not_chosen_spot?(spot)
          board.choose_spot(spot, mark)
        else
          spot = nil
        end
      end
    end
  end

  def get_spot(board)
    best_move = nil
    available_spaces = board.spots.select { |s| s != 'X' && s != 'O' }

    available_spaces.each do |as|
      board.spots[as.to_i] = mark
      if board.game_over?
        best_move = as.to_i
        board.spots[as.to_i] = as
        return best_move
      else
        board.spots[as.to_i] = other_player_mark
        if board.game_over?
          best_move = as.to_i
          board.spots[as.to_i] = as
          return best_move
        else
          board.spots[as.to_i] = as
        end
      end
    end

    return best_move if best_move

    n = rand(0..available_spaces.count)
    available_spaces[n].to_i
  end

  def other_player_mark
    mark == 'X' ? 'O' : 'X'
  end
end
