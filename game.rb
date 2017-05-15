# Write a program that lets two players face off in a game of tic-tac-toe. I'm
# deliberately leaving this open ended - feel free to use whatever language or
# format you would like. It could be a command line game which prints a board
# and asks for a square number, a web based game, or ... whatever floats your boat!

require 'pry'
require_relative 'board'
require_relative 'play'

class Game
  attr_accessor :move_count, :start_time, :grid, :play

  def initialize
    @move_count = 0
    @start_time = Time.now
    @grid = Board.new
    @current_player = "X"
  end

  def prompt(message)
    puts "=> #{message}"
  end

  def switch_player
    if @current_player == "X"
      @current_player = "O"
    else
      @current_player = "X"
    end
  end

  def start
    @play = Play.new(self)
    @play.start_game
  end

  def begin_play
    start_time
    @play.begin(@grid, @current_player)
  end

  def user_move(move)
    if !valid?(move)
      respond_with_not_valid
    else
      increment_move_count
      update_board(move)
      if @move_count >= 5
        return winning_sequence if winner?(move)
        return "It's a draw!" if draw?
      end
      switch_player
      next_turn
    end
  end

  def respond_with_not_valid
    @play.not_valid_prompt
  end

  def next_turn
    @play.next_turn(@grid, @current_player)
  end

  def winner?(move)
    @grid.winner?(move, @current_player)
  end

  def winning_sequence
    @play.winning_sequence
  end

  def update_board(move)
    @grid.update_board(move, @current_player)
  end

  def increment_move_count
    @move_count += 1
  end

  def draw?
    return false unless @grid.full?
    @play.draw
  end

  def valid?(move)
    valid_input?(move)
    @grid.eligible_square?(move)
  end

  def valid_input?(move)
    valid_inputs = %w( 1 2 3 4 5 6 7 8 9 )
    valid_inputs.include?(move)
  end

  def integer?(str)
    str.to_i.to_s == str ? true : false
  end
end

tic_tac_toe = Game.new
tic_tac_toe.start
