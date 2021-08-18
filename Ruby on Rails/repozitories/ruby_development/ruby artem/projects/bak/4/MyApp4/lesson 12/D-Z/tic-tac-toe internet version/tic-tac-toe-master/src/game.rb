require_relative 'board'
require_relative 'players/human'
require_relative 'players/computer'
require_relative '../lib/input_validator'

class Game
  include InputValidator

  attr_reader :board, :player1, :player2

  def self.start
    new.start
  end

  def initialize
    @board = Board.new
  end

  def start
    puts "Let the game begin"
    game_type = choose_game_type

    case game_type
    when :computer_vs_computer
      @player1 = Computer.new('O')
      @player2 = Computer.new('X')
    when :human_vs_human
      @player1 = Human.new('O')
      @player2 = Human.new('X')
    when :human_vs_computer
      @player1 = Human.new('O')
      @player2 = Computer.new('X', choose_game_level)
    end

    play
    puts "\nGame over"
  end

  def play
    board.print_current_board_state
    until board.game_over? || board.tie?
      player1.choose_spot(board)
      player2.choose_spot(board) if !board.game_over? && !board.tie?
      board.print_current_board_state
    end
  end
end
