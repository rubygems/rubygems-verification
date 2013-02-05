##
# Expects files in the format of "SHA  name.gem", uses File.basename on the
# name, path is irrelevant.
#
#   ruby shas_to_redis_sadd.rb rubygems-sha512.name.txt > redis.name.txt
#   redis-cli --pipe < redis.name.txt

# Modified from http://redis.io/topics/mass-insert

def gen_redis_proto *cmd
    proto = "*#{cmd.length}\r\n"
    cmd.each { |arg|
        proto << "$#{arg.bytesize}\r\n#{arg}\r\n"
    }
    proto
end

ARGF.each_line do |line|
  sha, path = line.chomp.split /\s+/

  name = File.basename path

  puts gen_redis_proto('MULTI')
  puts gen_redis_proto('HINCRBY', name, sha, '1')
  puts gen_redis_proto('EXEC')
end
