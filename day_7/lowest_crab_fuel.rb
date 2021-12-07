## Author: gitjiggywithit
## Date: 2020-12-07
## Purpose: Solving this puzzle --> https://adventofcode.com/2021/day/7
## Usage: ruby lowest_crab_fuel.rb

# crab positions are stored in a text file in csv format
c_pos = File.read('crab_positions.txt').chomp.split(',').map(&:to_i)
fuel_costs = {}
high_fuel_costs = {}
# create a range from 0 to the highest current crab position
all_pos = (0..c_pos.sort.pop)

# this loop finds the fuel costs for both parts 1 & 2
all_pos.each do |p|
  next unless fuel_costs[p].nil?
  fuel_costs[p] = 0
  high_fuel_costs[p] = 0
  c_pos.each do |d|
    fuel = (p - d).abs
    fuel_costs[p] += fuel
    high_fuel_costs[p] += (1..fuel).sum
  end
end

# sort the hashes based on fuel costs then take the first entry
lowest_cost = proc { |c| c.sort_by { |_,f| f }.shift }
basic_cost = lowest_cost.call fuel_costs
high_cost = lowest_cost.call high_fuel_costs

puts "The most fuel efficient postions are:\n" +
     "  Basic cost model --> position #{basic_cost[0]} with a cost of #{basic_cost[1]}\n" +
     "  High cost model --> position #{high_cost[0]} with a cost of #{high_cost[1]}"
