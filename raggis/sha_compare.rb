cf = open('rubygems-shas')
cf_list = cf.each_line.map { |l| l.split(/\s+/) }
cf_sums = Hash[cf_list.map! { |sum, n| [File.basename(n), sum] }]

db = open('bb-shas')
db_list = db.each_line.map { |l| l.split(/\s+/) }
db_sums = Hash[db_list.map! { |sum, n| n ? [File.basename(n), sum] : nil }.compact]

cf_sums.each do |name, sum|
  db_sum = db_sums[name]
  next puts "Missing : #{name}" unless db_sum
  puts "Mismatch: #{name}" unless db_sum == sum
end
