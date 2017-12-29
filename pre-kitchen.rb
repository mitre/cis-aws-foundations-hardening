#!/usr/bin/ruby
require 'yaml'

@run_kitchen = true
file_content = YAML.load_file(".kitchen.yml")
my_vars = file_content['driver']['variables']

my_vars.each_pair do |key, value|
  x = ENV.key?(value.split("'")[1]) ? "#{ENV[value.split("'")[1]]}" : 'unset'
  if x == 'unset'
    @run_kitchen = false
    puts "Please set #{value.split("'")[1]}"
  else
    puts key.to_s + ': ' + x.to_s
  end
end

puts ''
puts '----------'
puts 'You are OK to run Test Kitchen' if @run_kitchen == true
puts 'Please SET the above Envrioment variables before running kitchen' if @run_kitchen == false
