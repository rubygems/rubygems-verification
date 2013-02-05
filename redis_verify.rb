##
# This script requires redis running locally.  All items in redis will be
# flushed when running this script.
#
# This script takes the SHA512 checksums collected from S3, various mirrors
# and user submissions with large caches of gems, the list of gems yanked from
# the index (which still exist on S3, but are not accessible by `gem install`)
# and computes a list of gems that do not have matching SHA512 checksums on
# two or more mirrors.
#
# First it computes the list of yanked gem names from the yanked_gems.txt
#
# Then it flushes redis of all items.
#
# Then it imports SHA entries in from the mirrors and S3 into redis
#
# Then it extracts the items from redis that have two or fewer matching
# checksums and writes it to standard output including the number of hashes in
# redis and, if more than 3, the number of different hashes for that gem.

require 'rbconfig'
require 'hiredis'
require 'redis'

ruby = RbConfig.ruby

yanked = {}

IO.foreach 'yanked_gems.txt' do |line|
  /\['(?<name>.*?)', '(?<version>.*?)', '(?<platform>.*?)'\]/ =~ line

  next unless name

  gem = if platform == "ruby" then
          "#{[name, version].join "-"}.gem"
        else
          "#{[name, version, platform].join "-"}.gem"
        end

  yanked[gem] = true
end

redis = Redis.new

redis.flushall

imports = Dir['rubygems-sha512.*'].map do |file|
  Thread.start do
    inn, out = IO.pipe

    convert_pid = Process.spawn ruby, 'redis_sha_import.rb', file, out: out

    import_pid  = Process.spawn('redis-cli', '--pipe',
                                in: inn, out: IO::NULL, err: IO::NULL)

    out.close_write

    Process.waitpid convert_pid

    raise 'shas_to_redis_sadd.rb failed' unless $?.success?

    Process.waitpid import_pid

    raise 'redis-cli insert failed' unless $?.success?

    $stderr.puts "wrote #{file}"
  end
end

imports.each do |thread|
  thread.value
end

unverified = []

IO.foreach 'rubygems-sha512.S3.txt' do |line|
  sha, path = line.chomp.split /\s+/

  name = File.basename path

  next if yanked.include? name

  hash_count = redis.hget(name, sha).to_i

  unverified << "#{name} #{hash_count}" if hash_count < 3
end

puts unverified.sort

