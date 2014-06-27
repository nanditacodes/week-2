require 'pry'


def call_the_block
  puts "inside call_the_block"

  #jump_to_block
  yield

  puts "after yield"
end


call_the_block do |the_thing|
  puts "OH HAI"
end

call_the_block do
  puts "ABCDF"
end


puts "ALL DONE YO"
