#grep ~~~ archivesspace.out > log.txt
require 'date'
require 'time'

file = File.new("log.txt", "r")
data = []
first_date_time = DateTime.new;
last_date_time = DateTime.new;
while (line = file.gets)
  d = line.chomp.split(' ')
  if d[0].start_with?("Time")
    index = 4
  elsif d[0].start_with?("Doc")
    index = 2
  elsif d[0].start_with?("INDEX")
    index = 1
  else
    index = 0
  end

  first_date_time = d[index+2].gsub('[','')+" "+d[index+3] if first_date_time.to_s.start_with?('-')
  last_date_time = d[index+2].gsub('[','')+" "+d[index+3]
  diff = (Time.parse(last_date_time) - Time.parse(first_date_time)) / 3600
  if index == 2
    b = d[index].split('/')
    s = b[-1].gsub!(/\d+/,'')
    data << {:indexer_type=>s+" "+d[index+1], :date_time=>d[index+2].gsub('[','')+" "+d[index+3], :time=>d[index+3], :time_elapsed=>diff, :number=>d[index+7], :total=>d[index+9], :rec_type=>d[index+10], :repo=>d[index+14].gsub(/Time/,'').gsub(/Doc/,'').gsub(/INDEX/,'')}
  else
    data << {:indexer_type=>d[index].gsub('-0400','').gsub('BATCH','')+" "+d[index+1], :date_time=>d[index+2].gsub('[','')+" "+d[index+3], :time_elapsed=>diff, :time=>d[index+3], :time_since_start=>d[index+3], :number=>d[index+7], :total=>d[index+9], :rec_type=>d[index+10], :repo=>d[index+14].gsub(/Time/,'').gsub(/Doc/,'').gsub(/INDEX/,'')}
  end
end
data.each do | a |
  puts a.inspect
end
