#!/usr/bin/ruby

require 'optparse'
require 'open3'

options = {}
options[:elastic_home] = "/opt/elastic"

OptionParser.new do |opts|

  opts.banner = "Usage: spoon.rb -c CLIENT [options]"

  opts.on("--verbose", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-h","--help", "Show this message") do
    puts opts
    exit
  end

  options[:client] = false
  opts.on("-c","--client CLIENT","Name of client") do |client|
    options[:client] = client
  end

  options[:kettle_version] = "4.4.0"
  opts.on("-v","--version KETTLE_VERSION","Kettle Version (default: 4.4.0") do |version|
    options[:kettle_version] = version
  end

  options[:data_dir] = "#{options[:elastic_home]}/data"
  opts.on("-d","--data_dir DATA_DIR",
          "Data directory (default: #{options[:elastic_home]}/data)") do |data_dir|
    options[:data_dir] = data_dir
  end

end.parse!


if !options[:client] then
  puts "ERROR: You must supply a client name!"
  puts "run spoon.rb -h for help"
  exit
end







puts "Client: #{options[:client]}"
puts "Kettle version: #{options[:kettle_version]}"
puts "Data diretory: #{options[:data_dir]}"
puts "HOME=#{ENV['HOME']}"




# Point the .kettle directory to the client
Open3.popen3("ln -sfh #{options[:data_dir]}/#{options[:client]}/.kettle #{ENV['HOME']}/.kettle")



# Run spoon on OS X
if options[:kettle_version] < "5" then
  cmd = "open -n /opt/kettle/pdi-ce-#{options[:kettle_version]}/Data\\ Integration\\ 64-bit.app"
else
  cmd = "open -n /opt/kettle/pdi-ce-#{options[:kettle_version]}/Data\\ Integration.app"
end

puts "Command: #{cmd}"
Open3.popen3(cmd) do |stdin, stdout, stderr|
  puts stdout.read
  puts stderr.read
end
