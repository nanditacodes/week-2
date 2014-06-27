
module Helper2048

  def for_each_swappable_cell(columns:, rows:)
    3.times do
      columns.each do |column_number|
        rows.each do |row_number|
          if value_at([row_number, column_number]) == 0
            yield(row_number, column_number)
          end
        end
      end
    end

  end

  def for_each_cell_move_to
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |value, column_index|
        cell=[row_index, column_index]
        destination = yield(cell) if block_given?
        compare_and_combine(cell: cell,
                            destination: destination,
                            value: value)
      end
    end
  end

  def swap(args)
    position = args[:position]
    destination = args[:destination]

    position_value_before       = value_at(position)
    destination_value_before    = value_at(destination)

    set_value_for_cell(position, destination_value_before)
    set_value_for_cell(destination, position_value_before)

  end

  def open_cells
    cells = []
    @grid.each_with_index do |rows, row_index|
      rows.each_with_index do |columns, column_index|
        if value_at([row_index, column_index]) == 0
          cells << [row_index, column_index]
        end
      end
    end
    cells
  end

  def value_at(cell)
    x = cell.first
    y = cell.last
    row = @grid[x]
    if valid_index_values?(x, y)
      row[y]
    else
      0
    end
  end

  def valid_index_values?(x, y)
    [x, y].all? do |value|
      [0, 1, 2, 3].include? value
    end
  end

  def set_value_for_cell(cell, value)
    #[2,0]
    row = cell.first
    column = cell.last
    row = @grid[row]
    row[column] = value
  end

  def matrix_is_full?
    @grid.flatten.all? do |number|
      number > 0
    end
  end

  def game_is_over?
    full = matrix_is_full?
    pairs = any_adjacent_pairs?
    return full && !pairs
  end

  def any_adjacent_pairs?
    # for all positions in grid, run any_adjacent?

    found_adjacent = false

    @grid.each_with_index do |row, row_number|

      # 4 columns : 0, 1, 2, 3

      row.each_with_index do |column, index|
        if any_adjacent? row_number, index
          found_adjacent = true
        end
      end

    end
    return found_adjacent

  end

  def color_hash_for_number(number)

    text       = :black
    background = {
      0 => :light_black,
      2 => :light_yellow,
      4 => :yellow,
      8 => :light_cyan,
      16 =>:cyan,
      32 =>:light_green,
      64 =>:green,
      128=>:light_magenta,
      256=>:magenta,
      512=>:light_blue,
      1024=>:blue,
      2048=>:red
    }[number]

    return {color: text, background: background}
  end


  # example of keyword arguments in ruby
  def compare_and_combine (cell:, destination:, value:)
    if does_equal(cell, destination)
      set_value_for_cell(cell, 0)
      set_value_for_cell(destination, value * 2 )
      add_to_score(value * 2)
    end
  end

  def add_to_score(number)
    @score += number
  end

  def any_adjacent?(row, column)
    top = [row-1, column]
    left = [row, column-1]
    down = [row+1, column]
    right = [row, column+1]
    [top, left, down, right].any? do |position|
      does_equal([row, column], position)
    end
  end

  def does_equal(cell_one, cell_two)

    return false if value_at(cell_one) == 0

    value_at(cell_one) == value_at(cell_two)
  end

end
