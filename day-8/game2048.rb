require 'io/console'
require 'pry'
require './helper2048.rb'
require 'colorize'

class Endofgame < StandardError
end

class Game2048
  attr_accessor  :grid, :score, :messages

  include Helper2048

  def initialize
    @grid = Array.new(4) {Array.new(4) {0}}
    @score = 0;
    @messages = []
  end

  def apply_move_to_grid(move)

    case move.downcase
    when 'w' then self.move_up
    when 'a' then self.move_left
    when 'd' then self.move_right
    when 's' then self.move_down

    when 'q' then exit
    else
      # we need to show this message,
      # after the screen has been cleared
      @messages <<  "Sorry, please enter one of w, a, d, s"
    end
  end

  def print_grid
    @grid.each do |row|
      row.each do |i|

        value_to_show = i.to_s
        value_to_show = "" if i == 0

        colored_value = value_to_show.center(4).colorize(color_hash_for_number(i))
        print "|#{colored_value}|"
      end
      print "\n"
    end
  end

  def print_messages
    @messages.each do |message|
      puts "*** -> #{message}"
    end
    @messages = []
  end

  def add_random_to_grid
    value_to_add = rand() < 0.6667 ? 2 : 4

    chosen_cell = open_cells.sample
    if chosen_cell
      set_value_for_cell(chosen_cell, value_to_add)
    end
  end

  def move_left

    columns = [0, 1, 2]
    rows = [0, 1, 2, 3]

    for_each_cell_move_to do |cell|
      destination = [cell.first, cell.last - 1]
    end

    for_each_swappable_cell(columns: columns, rows: rows) do |row_number, column_number|
      swap(position: [row_number,column_number + 1], destination: [row_number,column_number])
    end

  end

  def move_right

    columns = [3, 2, 1]
    rows = [0, 1, 2, 3]

    for_each_cell_move_to do |cell|
      destination = [cell.first, cell.last + 1]
    end

    for_each_swappable_cell(columns: columns, rows: rows) do |row_number, column_number|
      swap(position: [row_number,column_number - 1], destination: [row_number,column_number])
    end

  end

  def move_down

    columns = [0, 1, 2, 3]
    rows = [3, 2, 1]

    for_each_cell_move_to do |cell|
      destination = [cell.first + 1, cell.last]
    end

    for_each_swappable_cell(columns: columns, rows: rows) do |row_number, column_number|
      swap(position: [row_number-1,column_number], destination: [row_number,column_number])
    end

  end

  def move_up

    columns = [0, 1, 2, 3]
    rows = [0, 1, 2]

    for_each_cell_move_to do |cell|
      destination = [cell.first-1 , cell.last]
    end

    for_each_swappable_cell(columns: columns, rows: rows) do |row_number, column_number|
      swap(position: [row_number+1,column_number], destination: [row_number,column_number])
    end

  end


  def print_header

    score = @score.to_s.center(16)
    score_line = "    [ #{score}]".colorize(color: :red)

    puts "\nEnter Q to quit!\n"
    puts "CONTROLS: w, a, d, s"
    puts "---------------------"
    puts ""
    puts "    [-----------------]".colorize(color: :red)
    puts game_is_over? ? score_line.blink : score_line
    puts "    [-----------------]".colorize(color: :red)
    puts ""

  end

  def redraw_screen
    system "clear" or system "cls"
    self.print_header
    self.print_messages
    self.print_grid
  end

  def run_game
    # start by filling a couple of cells.
    2.times do
      self.add_random_to_grid
    end

    until game_is_over?
      redraw_screen
      move = STDIN.getch

      original_grid_values = @grid.flatten
      apply_move_to_grid(move)
      if original_grid_values != @grid.flatten
        self.add_random_to_grid
      end
        raise Endofgame if game_is_over?
    end
  end
end

begin
  @grid = Game2048.new
  @grid.run_game
rescue Endofgame
  redraw_screen

  puts "-----------------------------------"
  puts "[                                 ]"
  puts "[          IT'S ALL OVER!         ]".blink
  puts "[                                 ]"
  puts "-----------------------------------"
end
