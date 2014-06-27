number = 2
result = 0

until result == 2048
  result = 2 ** number
  puts "#{number} => #{result}"
  number += 1
end
