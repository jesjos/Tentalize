require 'rubygems'
require 'vpim/icalendar'
require 'vpim'
require 'rest_client'
require 'nokogiri'
require 'active_record'
require 'yaml'
require 'sqlite3'

newFile = String.new
calendarDoc = RestClient.get 'http://timeedit.ita.chalmers.se/4DACTION/WebShowSearch/1/1-0?wv_type=7&wv_category=704&wv_ts=20101015T213723X4224&wv_search=&wv_startWeek=1041&wv_stopWeek=1043&wv_first=0&wv_addObj=&wv_delObj=&wv_obj1=8765000&wv_obj2=8767000&wv_obj3=8766000&wv_obj4=8764000&wv_obj5=8770000&wv_obj6=8838000&wv_obj7=8768000&wv_obj8=8769000&wv_obj9=8760000&wv_obj10=8763000&wv_obj11=8761000&wv_obj12=8762000&wv_graphic=Grafiskt+format'
htmldoc = Nokogiri::HTML(calendarDoc)
htmldoc.xpath('//td/small/a').each do |tag|
  if tag.text.include? 'iCal'
    newFile = "http://timeedit.ita.chalmers.se#{tag.attribute('href')}"
  end
end
cal = Vpim::Icalendar.decode(RestClient.get newFile)
dbCal = Marshal::dump(cal)



# hash = {}
# cal.each do |cal|
#   cal.events.each do |c|
#    if hash.has_key? c.location
#      hash[c.location].push(c.occurences.first)
#    else
#      hash[c.location] = [c.occurences.first]
#    end
#   end
# end
# hash.each do |loc,bap| puts "#{loc} -> #{bap}" end
# # nokogiri, restclient