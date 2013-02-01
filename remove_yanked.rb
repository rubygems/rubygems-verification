##
# This converts yanked_gems.txt which is in a JSON-like format into gem names

yanked = []

IO.foreach 'yanked_gems.txt' do |line|
  /\['(?<name>.*?)', '(?<version>.*?)', '(?<platform>.*?)'\]/ =~ line

  next unless name

  yanked << if platform == "ruby" then
              "#{[name, version].join "-"}.gem"
            else
              "#{[name, version, platform].join "-"}.gem"
            end
end

unverified = []

IO.foreach 'unverified.txt' do |line|
  _, name = line.chomp.split /\s+/

  unverified << File.basename(name)
end

puts unverified - yanked

