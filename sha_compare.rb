##
# To check if you have checksums for unverified gems:
#
#   ruby sha_compare.rb unverified.txt new_checksums.txt | wc -l
#
# This will count how many unverified checksums remain and show any mismatches
#
# To generate a new unverified list:
#
#   ruby sha_compare.rb unverified.txt new_checksums.txt > new_unverified.txt

cf = open ARGV.shift
cf_list = cf.each_line.map { |l| l.split(/\s+/) }
cf_sums = Hash[cf_list.map! { |sum, n| [File.basename(n), sum] }]

db = open ARGV.shift
db_list = db.each_line.map { |l| l.split(/\s+/) }
db_sums = Hash[db_list.map! { |sum, n| [File.basename(n), sum] }]

cf_sums.each do |name, sum|
  db_sum = db_sums[name]

  next if db_sum == sum

  $stderr.puts "Mismatch: #{name}" unless db_sum.nil?
  puts "#{sum}  ./#{name}"
end
