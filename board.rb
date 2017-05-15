class Board
  attr_accessor :grid

  def initialize
    @grid = default_grid
  end

  def default_grid
    [{[0, 0] => "1"}, {[0, 1] => "2"}, {[0, 2] => "3"},
     {[1, 0] => "4"}, {[1, 1] => "5"}, {[1, 2] => "6"},
     {[2, 0] => "7"}, {[2, 1] => "8"}, {[2, 2] => "9"}]
  end

  def eligible_square?(move)
    coordinates = get_coordinates(move)
    val = find_value(find_index(coordinates))
    integer?(val)
  end

  def integer?(str)
    str.to_i.to_s == str ? true : false
  end

  def find_value(index)
    grid[index].values[0]
  end

  def find_index(coordinates)
    grid.index { |sq| sq.keys[0] == coordinates }
  end

  def update_board(move, player)
    coordinates = get_coordinates(move)
    @grid.each do |sq|
      if sq.keys[0] == coordinates
        sq.values[0].replace(player)
      end
    end
    @grid
  end

  def get_coordinates(move)
    square = default_grid.select {|sq| sq.values[0] == move }
    square[0].keys[0]
  end

  def descending_diagonal_coordinates
    [[0, 0], [1, 1], [2, 2]]
  end

  def ascending_diagonal_coordinates
    [[2, 0], [1, 1], [0, 2]]
  end

  def check_row(x, y, current_player)
    row = grid.select {|sq| sq.keys[0][0] == x}
    row.all? {|sq| sq.values[0] == current_player}
  end

  def check_column(x, y, current_player)
    column = grid.select {|sq| sq.keys[0][1] == y}
    column.all? { |sq| sq.values[0] == current_player }
  end

  def check_diagonal(x, y, current_player)
    if descending_diagonal_coordinates.include?([x, y])
      diag = grid.select { |sq| descending_diagonal_coordinates.include? sq.keys[0] }
      diag.all? { |sq| sq.values[0] == current_player }
    end

    if ascending_diagonal_coordinates.include?([x, y])
      diag = grid.select { |sq| ascending_diagonal_coordinates.include? sq.keys[0] }
      diag.all? { |sq| sq.values[0] == current_player }
    end
  end

  def full?
    grid.all? {|box| !integer?(box.values[0])}
  end

  def winner?(move, current_player)
    coordinates = get_coordinates(move)
    x, y = coordinates[0], coordinates[1]
    return true if check_row(x, y, current_player)
    return true if check_column(x, y, current_player)
    if !(y - x == 1 || y - x == -1)
      return true if check_diagonal(x, y, current_player)
    end
  end
end
