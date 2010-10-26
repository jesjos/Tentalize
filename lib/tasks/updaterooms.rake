desc 'Get room names and save them to the database'
task :updaterooms => :environment do 
  html = RestClient.get("http://timeedit.ita.chalmers.se/4DACTION/WebShowSearch/1/1-0?wv_type=7&wv_category=704&wv_ts=20101025T190210X1764&wv_search=&wv_startWeek=1043&wv_stopWeek=1044&wv_first=0&wv_addObj=")
  parsed = Nokogiri::HTML(html)
  nodes = parsed.css("table:nth-child(3) td:nth-child(3)")
  nodes.each {|node| Room.new(:name => node.text, :object_id => node.parent.at_css("a")[:href].match('\((.+)\)')}
end
  