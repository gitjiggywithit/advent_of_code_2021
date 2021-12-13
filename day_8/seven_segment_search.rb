## Author: gitjiggywithit
## Date: 2020-12-08
## Purpose: Solving this puzzle --> https://adventofcode.com/2021/day/8
## Usage: ruby seven_segment_search.rb <path_to_input>

KNOWN_NUMS = [1,4,7,8].freeze
KNOWN_LENGTHS = { 1 => 2, 2 => 5, 4 => 4, 7 => 3, 8 => 7 }.freeze
CONF = {
  0 => [1,2,3,5,6,7],
  1 => [3,6],
  2 => [1,3,4,5,7],
  3 => [1,3,4,6,7],
  4 => [2,3,4,6],
  5 => [1,2,4,6,7],
  6 => [1,2,4,5,6,7],
  7 => [1,3,6],
  8 => (1..7).to_a,
  9 => [1,2,3,4,6,7],
}.freeze
ss_data = File.read(ARGV[0]).split("\n").map{ |e| e.split(' | ') }.to_h


# **** BEGIN PART 1 ****
def known_value?(val)
  l = val.length
  l == 2 || l == 3 || l == 4 || l == 7
end

kv_count = 0
ss_data.each_value do |v|
  v.split.each { |e| kv_count += 1 if known_value?(e) }
end
puts "Count of known values: #{kv_count}"
# **** END PART 1 ****


# **** BEGIN PART 2 ****
# simple method to convert a string of all alphanumeric chars into an array
def s_to_a(str)
  str.split('')
end

# create a cipher based on the provided pattern
def gen_cipher(pattern)
  segments = {}
  cipher = {}
  KNOWN_NUMS.each { |n| cipher[n] = pattern.select { |e| e.length == KNOWN_LENGTHS[n] }.pop }
  p_to_check = [s_to_a(cipher[1]), s_to_a(cipher[4]) - s_to_a(cipher[1])]
  segments[1] = (s_to_a(cipher[7]) - p_to_check[0]).pop

  # use patterns with 6 chars to deduce segments 3,6,4 and 2
  six_len = pattern.select { |e| e.length == 6 }
  matched_pats = []
  six_len.each do |pat|
    p_to_check.each_with_index do |cp, i|
      cseg = i.zero? ? [3,6] : [4,2]
      cp.each do |char|
        if !pat.include? char
          matched_pats << pat
          segments[cseg[0]] = char
          segments[cseg[1]] = cp.find { |c| c != char }
        end
      end
    end
  end
  matched_pats.each { |pat| six_len.delete pat }

  segments[5] = (s_to_a(cipher[8]) - s_to_a(six_len[0])).pop
  segments[7] = (('a'..'g').to_a - segments.values).pop

  CONF.each do |seg, conf|
    next unless cipher[seg].nil?
    generated_pat = ''
    conf.each { |n| generated_pat << segments[n] }
    pattern.each do |pat|
      next unless pat.length == generated_pat.length
      if pat.each_char.sort == generated_pat.each_char.sort
        cipher[seg] = pat
        break
      end
    end
  end

  return cipher
end

# use a generated cipher to decode the corresponding output
def decipher(cipher, output)
  decoded_output = ''
  output.split.each do |o|
    matched_num = cipher.find { |_,v| s_to_a(v).sort == s_to_a(o).sort }[0].to_s
    decoded_output << matched_num
  end
  return decoded_output
end

decoded_outputs = []
ss_data.each do |pattern, output|
  cipher = gen_cipher(pattern.split)
  decoded_outputs << decipher(cipher, output)
end

puts "Sum of all decoded outputs: #{decoded_outputs.map(&:to_i).sum}"
# **** END PART 2 ****
