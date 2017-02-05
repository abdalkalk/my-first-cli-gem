require_relative "./city.rb"
require_relative "./cline.rb"
require_relative "./hotel.rb"
require 'colorize'
require 'open-uri'
require 'pry'
require 'nokogiri'
class Scrap
def self.start_nokogiri(city_name)
if city_name == "erbil"
html=open("http://www.booking.com/searchresults.html?aid=7344259;label=metatripad-link-dmetanar-hotel-572255_xqdz-2160b895b20379275615da7ce1accb60_los-01_bw-052_dom-com_curr-IQD_gst-02_nrm-01_clkid-WInfXgoQIW8AAHE2vB0AAABG_aud-0000_mbl-M_pd-B_sc-2;sid=ab45cb9c3d61edaab36a87657e4bd130;checkin=2017-03-19;checkout=2017-03-20;dest_id=-3106433;dest_type=city;highlighted_hotels=572255;hlrd=12;keep_landing=1;redirected=1;source=hotel&utm_campaign=nar&utm_content=los-01_bw-052_dom-com&utm_medium=dmeta&utm_source=metatripad&utm_term=hotel-572255&")
else
html=open("http://www.booking.com/searchresults.en-gb.html?aid=7344259;label=metatripad-link-dmetanar-hotel-572255_xqdz-2160b895b20379275615da7ce1accb60_los-01_bw-052_dom-com_curr-IQD_gst-02_nrm-01_clkid-WInfXgoQIW8AAHE2vB0AAABG_aud-0000_mbl-M_pd-B_sc-2;sid=ab45cb9c3d61edaab36a87657e4bd130;checkin_month=3;checkin_monthday=19;checkin_year=2017;checkout_month=3;checkout_monthday=20;checkout_year=2017;city=-3106433;class_interval=1;dest_id=-3103581;dest_type=city;group_adults=2;group_children=0;highlighted_hotels=805888;hlrd=0;label_click=undef;no_rooms=1;offset=0;qrhpp=49f276a70adc52941d2535c7fc06a945-hotel-0;room1=A%2CA;sb_price_type=total;search_pageview_id=290649fe9fd0018f;search_selected=0;src=searchresults;src_elem=sb;ss=Baghdad;ss_raw=Baghdad;ssb=empty;srpos=5;origin=search")
end
doc=Nokogiri::HTML(html)
doc1=doc.css("div#ajaxsrwrap")
name= doc1.css("h3.sr-hotel__title a.hotel_name_link.url span.sr-hotel__name")
rate= doc1.css("a span.js--hp-scorecard-scoreword")
city= doc1.css("div.address")
booked = doc1.css("span.lastbooking")
details = doc1.css("span.lastbooking")
Hotel.clear_all
City.clear_all
Scrap.fill_info(name,rate,city,booked,details)
end

def self.fill_info(name,rate,city,booked,details)
  names=[]
  rates=[]
  cities=[]
  bookeds=[]
  details1=[]
name.each_with_index do |n,index|
  n1 = n.text.split("\n")
  n1.shift
  n2 = n1.join(",")
  names << n2.strip
end
details.each_with_index do |d,index|
  d1 = d.text.split("\n")
  d1.shift
  d2 = d1.join(",")
  details1 << d2.strip
end
rate.each_with_index do |r,index|
  r1 = r.text.split("\n")
  r1.shift
  r2 = r1.join(",")
  rates << r2.strip
end
booked.each_with_index do |b,index|
  b1 = b.text.split("\n")
  b1.shift
  b2=b1.join(",")
  bookeds << b2.strip
end
city.each_with_index do |c,index|
  c1 = c.text.split("\n")
  c1.shift
  c2 = c1.join(",")
  c3=c2.split("")
  c3.delete_at(0)
  c3[0]=c3[0].downcase
  c4 = c3.join("")
  cities << c4
end
Scrap.set_instant_value(names,cities,rates,bookeds,details1)
end
#******************************************************
def self.set_instant_value(names,cities,rates,bookeds,details1)
  i=0
  c=[]
  hotel_obj=[]
while i < names.size
  # puts "#{i+1}) #{names[i]}  #{cities[i]}  #{rates[i]}".green
  c[i]= City.new("#{cities[i]}")
  hotel_obj << Hotel.new("#{names[i]}",c[i],"#{rates[i]}","#{bookeds[i]}","#{details1[i]}")
  i+=1
end
return hotel_obj
end
#*********************************************************
end
