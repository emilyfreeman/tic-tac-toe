require_relative 'timer'

class Play
  def initialize(game)
    @game = game
  end

  def prompt(message)
    puts "=> #{message}"
  end

  def start_game
    prompt("Welcome to Tic Tac Toe")
    prompt("Would you like to (p)lay, read the (i)nstructions or (q)uit?")
    input
  end

  def play_again?
    prompt("Would you like to (p)lay again?")
    input
  end

  def begin(grid, current_player)
    print_board(grid)
    first_move(current_player)
  end

  def input
    input = gets.chomp.upcase
    case
    when input == "Q"
      quit
    when input == "I"
      instructions
    when input == "P"
      @game.begin_play
    else
      @game.user_move(input)
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

  def print_board(grid)
    prompt("#{grid.print_board}")
  end

  def first_move(current_player)
    prompt("Player #{current_player}: What's your first move?")
    input
  end

  def not_valid_prompt
    prompt("That's not a valid move.")
    next_turn
  end

  def next_turn(grid, current_player)
    prompt("Player #{current_player}: What's your next move?")
    print_board(grid)
    input
  end

  def winning_sequence
    prompt("You won! Congrats!")
    print_game_time
    play_again?
  end

  def draw
    prompt("It's a draw!")
    print_game_time
    play_again?
  end

  def print_game_time
    timer = Timer.new
    prompt("This game lasted #{timer.game_time(@game.start_time)}")
  end

  def print_board(grid)
    prompt("
      ===================
      |  #{grid.find_value(0)}  |  #{grid.find_value(1)}  |  #{grid.find_value(2)}  |
      -------------------
      |  #{grid.find_value(3)}  |  #{grid.find_value(4)}  |  #{grid.find_value(5)}  |
      -------------------
      |  #{grid.find_value(6)}  |  #{grid.find_value(7)}  |  #{grid.find_value(8)}  |
      =================== ")
  end
end
