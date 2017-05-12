# Write a program that lets two players face off in a game of tic-tac-toe. I'm
# deliberately leaving this open ended - feel free to use whatever language or
# format you would like. It could be a command line game which prints a board
# and asks for a square number, a web based game, or ... whatever floats your boat!

require 'pry'
class Game
  attr_accessor :move_count, :start_time, :grid

  def initialize
    @move_count = 0
    @start_time = Time.now
    @grid = default_grid
    @current_player = "X"
  end

  def switch_player
    if @current_player == "X"
      @current_player = "O"
    else
      @current_player = "X"
    end
  end

  def start
    start_game
  end

  def fetch_code
    c = Code.new
    c.generate
  end

  def prompt(message)
    puts "=> #{message}"
  end

  def start_game
    prompt("Welcome to Tic Tac Toe")
    prompt("Would you like to (p)lay, read the (i)nstructions or (q)uit?")
    input
  end

  def input
    input = gets.chomp.upcase
    case
    when input == "Q"
      quit
    when input == "I"
      instructions
    when input == "P"
      begin_play
    else
      user_move(input)
    end
  end

  def quit
    prompt("Goodbye!")
  end

  def instructions
    prompt("Tic Tac Toe is a two-player game. The board is a 3x3 grid. The
      first player to go will be assigned \"X\" and the second player \"O\".
      Your objective is to place your \"X\" or \"O\" in 3 squares in a row —
      this could be horizontally, vertically or diagonally. The first player
      to accomplish this wins.")
    prompt("When you're ready to play, first player should input the number
      corresponding with the box in which they want to place their symbol.")
    prompt("Would you like to (p)lay or (q)uit?")
    input
  end

  def default_grid
    [{[0, 0] => "1"}, {[0, 1] => "2"}, {[0, 2] => "3"},
     {[1, 0] => "4"}, {[1, 1] => "5"}, {[1, 2] => "6"},
     {[2, 0] => "7"}, {[2, 1] => "8"}, {[2, 2] => "9"}]
  end

  def print_board
    "
      ===================
      |  #{find_value(0)}  |  #{find_value(1)}  |  #{find_value(2)}  |
      -------------------
      |  #{find_value(3)}  |  #{find_value(4)}  |  #{find_value(5)}  |
      -------------------
      |  #{find_value(6)}  |  #{find_value(7)}  |  #{find_value(8)}  |
      =================== "
  end

  def find_value(index)
    @grid[index].values[0]
  end

  def begin_play
    prompt("Remember, enter the number that corresponds with the box in which
      you want to place \"X\".")
    prompt("#{print_board}")
    start_time
    prompt("Player #{@current_player}: What's your first move?")
    input
  end

  def next_turn
    prompt("Player #{@current_player}: What's your next move?")
    prompt("#{print_board}")
    input
  end

  def user_move(move)
    if !valid_move?(move)
      prompt("That's not a valid move.")
      next_turn
    else
      coordinates = get_coordinates(move)
      return "You won!" if winner?(coordinates)
      return "It's a draw!" if draw?
      update_board(coordinates)
      switch_player
      next_turn
    end
  end

  def update_board(coordinates)
    @grid.each do |sq|
      if sq.keys[0] == coordinates
        sq.values[0].replace(@current_player)
      else
        sq.values[0] = sq.values[0]
      end
    end
    @grid
  end

  def draw?
    return false unless @grid.all? {|box| !integer?(box.values[0])}
    prompt("It's a draw!")
  end

  def winner?(coordinates)
    x, y = coordinates[0], coordinates[1]
    return true if check_row(x, y)
    return true if check_column(x, y)
    if !(y - x == 1 || y - x == -1)
      return true if check_diagonal(x, y)
    end
    false
  end

  def check_row(x, y)
    row = @grid.select {|sq| sq.keys[0][0] == x}
    return false unless row.all? {|sq| sq.values == @current_player}
  end

  def check_column(x, y)
    column = @grid.select {|sq| sq.keys[0][1] == y}
    return false unless column.all? { |sq| sq.values == @current_player }
  end

  def check_diagonal(x, y)
    if descending_diagonal_coordinates.include?([x, y])
      diag = @grid.select { |sq| descending_diagonal_coordinates.include? sq.keys[0] }
      return false unless diag.all? { |sq| sq.values == @current_player }
    end

    if ascending_diagonal_coordinates.include?([x, y])
      diag = @grid.select { |sq| descending_diagonal_coordinates.include? sq.keys[0] }
      return false unless diag.all? { |sq| sq.values == @current_player }
    end
  end

  def descending_diagonal_coordinates
    [[0, 0], [1, 1], [2, 2]]
  end

  def ascending_diagonal_coordinates
    [[2, 0], [1, 1], [0, 2]]
  end

  def valid_move?(move)
    valid_inputs = %w( 1 2 3 4 5 6 7 8 9 )
    valid_inputs.include?(move)
    move.length == 1 && integer?(move) # check this out for unnecessary
  end

  def integer?(str)
    str.to_i.to_s == str ? true : false
  end

  # def correct_colors(move)
  #   move.uniq.find_all { |e| @code.uniq.include? e }.count
  # end

  # def correct_positions(move)
  #   combo = @code.zip(move)
  #   combo.find_all { |e| e[0] == e[1] }.count
  # end

  def guess_syntax
    guess_count == 1 ? "guess" : "guesses"
  end

  def minutes_syntax(minutes)
    minutes == 1 ? "minute" : "minutes"
  end

  def seconds_syntax(seconds)
    seconds == 1 ? "second" : "seconds"
  end

  def game_time
    time_score = ((Time.now - @start_time).to_i)
    minutes = time_score / 60
    seconds = time_score % 60
    "#{minutes} #{minutes_syntax(minutes)} and #{seconds} #{seconds_syntax(seconds)}"
  end

  def feedback(move)
    if @code == move
      prompt("Congratulations! You moveed the sequence #{@code.join} in #{move_count} #{move_syntax} with a time score of #{game_time}.")
    else
      @move_count += 1
      prompt("#{move.join} has #{correct_colors(move)} of the correct elements with #{correct_positions(move)} in the correct positions. You've taken #{move_count} #{move_syntax}.")
      next_turn
    end
  end

  def get_coordinates(move)
    map = {
      "1" => [0, 0],
      "2" => [0, 1],
      "3" => [0, 2],
      "4" => [1, 0],
      "5" => [1, 1],
      "6" => [1, 2],
      "7" => [2, 0],
      "8" => [2, 1],
      "9" => [2, 2]
    }
    map[move]
  end
end

tic_tac_toe = Game.new
tic_tac_toe.start
