## Author: gitjiggywithit
## Date: 2020-12-09
## Purpose: Solving this puzzle --> https://adventofcode.com/2021/day/9
## Usage: bundle exec ruby smoke_basin.rb <path_to_input>

require 'colorize'
require 'pry'

# create multi-dimensional array of heights using the given heightmap
@heights = File.readlines(ARGV[0]).map{ |l| l.chomp.split('').map(&:to_i) }

# given a coordinate for a point, return the coordinates and values of the
# points that surround it.
def adj(point_pos)
  outer = point_pos[0]
  inner = point_pos[1]
  u_pos = [outer-1, inner]
  d_pos = [outer+1, inner]
  l_pos = [outer, inner-1]
  r_pos = [outer, inner+1]

  # check for any nil or negative coordinates
  chk = proc do |pos|
    @heights[pos[0]].nil? || pos.any? { |e| e < 0 }
  end

  # store the values of the surrounding points. set invalid points to nil.
  u = chk.call(u_pos) ? nil : @heights[u_pos[0]][inner]
  d = chk.call(d_pos) ? nil : @heights[d_pos[0]][inner]
  l = chk.call(l_pos) ? nil : @heights[outer][l_pos[1]]
  r = chk.call(r_pos) ? nil : @heights[outer][r_pos[1]]

  # return coordinates and their values while rejecting all nil values
  return { u_pos => u, d_pos => d, l_pos => l, r_pos => r }.reject{ |_,v| v.nil? }
end

# boolean method that returns true if the passed coordinates are for a low point
def low_point?(point_pos)
  point = @heights[point_pos[0]][point_pos[1]]
  is_low_point = []
  adj(point_pos).each_value do |adj_point|
    is_low_point << (adj_point > point)
  end
  return is_low_point.all?
end

# add 1 to all low points, then sum to determine the risk level
def risk_level(low_points)
  low_points.map{ |pt| pt + 1 }.sum
end

# given a particular point, check for untested adjacencies
def more_adjacencies(point_pos)
  more_pos = {}
  info = adj(point_pos)

  info.each do |pos, num|
    next if @tested.include?(pos)
    more_pos[pos] = num
  end

  return more_pos
end

# this is a recursive method that keeps iterating until all of the points in a
# particular basin have been found
def basin(adj_points, start=nil)
  @tested ||= [start]
  @basin ||= [start]
  adj_points.each do |adj_pos, adj_num|
    next if adj_num.eql? 9
    next if @tested.include? adj_pos
    ma = more_adjacencies(adj_pos)
    @basin << ma.keys
    @tested << adj_pos
    unless ma.empty?
      self.basin(ma)
    end
  end
end


# *** PART 1 LOGIC ***
puts "Checking for low points..."
low_points = []
low_positions = []
@heights.each_with_index do |_, outer_i|
  @heights[outer_i].each_with_index do |_, inner_i|
    point_pos = [outer_i, inner_i]
    if low_point?(point_pos)
      low_points << @heights[outer_i][inner_i]
      low_positions << point_pos
    end
  end
end

puts "Found #{low_points.count} low points"
puts "Risk level: #{risk_level(low_points)}\n\n"
# *** END PART 1 ***

# *** PART 2 LOGIC ***
puts "Using low points to determine the size of their basins..."
basin_sizes = []
stored_output = {}
low_positions.each do |low_pos|
#  puts "*** STARTING BASIN SIZE CHECK FOR LOW POINT #{low_pos} ***"
  basin(adj(low_pos), low_pos)
#  puts "BASIN SIZE: #{@tested.size}"
  basin_sizes << @tested.size

  # debug to store a string that highlights the low point and all points
  # in that basin. Very useful to visualize if something is not as expected.
  output = ''
  @heights.each_with_index do |row, ri|
    line = ''
    row.each_with_index do |col, ci|
      ind = [ri,ci]
      if @tested.include? ind
        if low_pos == ind
          line << col.to_s.bold.on_red
        else
          line << col.to_s.bold.on_blue
        end
      else
        line << col.to_s
      end
    end
    output << line + "\n"
  end
  stored_output[low_pos] = output
  # END DEBUG

  # clear instance variables
  @tested = nil
  @basin = nil
end

# Use pry to drop into a shell and debug the results if necessary
#binding.pry

total = 1
largest = basin_sizes.sort()[-3..-1]
puts "Largest three basins: #{largest}"
largest.each { |n| total = n * total }
puts "Multiplied size of three largest basins: #{total}"
# *** END PART 2 ***
