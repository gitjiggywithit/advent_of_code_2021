## Author: gitjiggywithit
## Date: 2020-12-06
## Purpose: Solving this puzzle --> https://adventofcode.com/2021/day/1
## Usage: ruby compare_depths.rb

depths = File.readlines('depths.txt').map{ |d| d.chomp.to_i }
larger_count = 0
larger_count_sw = 0
depths.each_with_index do |cd, i|
  # part 1 logic
  # count number of depths larger than previous
  next if i.zero?
  pd = depths[i-1]
  larger_count += 1 if cd > pd
  # part 2 logic
  # count number of sliding window depths larger than previous
  next if i < 3
  pdw = depths[i-3..i-1].sum
  cdw = depths[i-2..i].sum
  larger_count_sw += 1 if cdw > pdw
end
puts "Total depths larger than previous: #{larger_count}"
puts "Total depths larger than previous sliding window: #{larger_count_sw}"
