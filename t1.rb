require 'nokogiri'
require 'open-uri'
require 'colorize'

class Scrap
def self.start_nokogiri(city_name)
  if city_name == "erbil"
html=open("http://www.booking.com/searchresults.html?aid=7344259;label=metatripad-link-dmetanar-hotel-572255_xqdz-2160b895b20379275615da7ce1accb60_los-01_bw-052_dom-com_curr-IQD_gst-02_nrm-01_clkid-WInfXgoQIW8AAHE2vB0AAABG_aud-0000_mbl-M_pd-B_sc-2;sid=ab45cb9c3d61edaab36a87657e4bd130;checkin=2017-03-19;checkout=2017-03-20;dest_id=-3106433;dest_type=city;highlighted_hotels=572255;hlrd=12;keep_landing=1;redirected=1;source=hotel&utm_campaign=nar&utm_content=los-01_bw-052_dom-com&utm_medium=dmeta&utm_source=metatripad&utm_term=hotel-572255&")
else
html=open("http://www.booking.com/searchresults.en-gb.html?aid=7344259;label=metatripad-link-dmetanar-hotel-572255_xqdz-2160b895b20379275615da7ce1accb60_los-01_bw-052_dom-com_curr-IQD_gst-02_nrm-01_clkid-WInfXgoQIW8AAHE2vB0AAABG_aud-0000_mbl-M_pd-B_sc-2;sid=ab45cb9c3d61edaab36a87657e4bd130;checkin_month=3;checkin_monthday=19;checkin_year=2017;checkout_month=3;checkout_monthday=20;checkout_year=2017;city=-3106433;class_interval=1;dest_id=-3103581;dest_type=city;group_adults=2;group_children=0;highlighted_hotels=805888;hlrd=0;label_click=undef;no_rooms=1;offset=0;qrhpp=49f276a70adc52941d2535c7fc06a945-hotel-0;room1=A%2CA;sb_price_type=total;search_pageview_id=290649fe9fd0018f;search_selected=0;src=searchresults;src_elem=sb;ss=Baghdad;ss_raw=Baghdad;ssb=empty;srpos=5;origin=search")
end
doc=Nokogiri::HTML(html)
# exit (1)
# puts doc
doc1=doc.css("div#ajaxsrwrap")
name= doc1.css("h3.sr-hotel__title a.hotel_name_link.url span.sr-hotel__name")
rate= doc1.css("a span.js--hp-scorecard-scoreword")
city= doc1.css("div.address")
booked = doc1.css("span.lastbooking")
Scrap.fill_info(name,rate,city,booked)
end

def self.fill_info(name,rate,city,booked)
  names=[]
  rates=[]
  cities=[]
  bookeds=[]
name.each_with_index do |n,index|
  n1 = n.text.split("\n")
  n1.shift
  n2 = n1.join(",")
  names << n2.strip
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
Scrap.set_instant_value(names,cities,rates,bookeds)
end
# ******************************************************
def self.set_instant_value(names,cities,rates,bookeds)
  i=0
  c=[]
  hotel_obj=[]
while i < names.size
  # puts "#{i+1}) #{names[i]}  #{cities[i]}  #{rates[i]}".green
  c[i]= City.new("#{cities[i]}")
  hotel_obj << Hotel.new("#{names[i]}",c[i],"#{rates[i]}","#{bookeds[i]}")
  i+=1
end
return hotel_obj
end
# *********************************************************
end
# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# ////////////////////////////////////////////////////////////

class Hotel
  @@all=[]
   attr_accessor :hotel_name,:city,:hotel_rating,:hotel_price,:hotel_booked
#-----------------------------------------------------------------
   def initialize(hotel_name,city,hotel_rating,hotel_price="100$",hotel_booked)
    @hotel_name=hotel_name
    self.city=city
    @hotel_rating=hotel_rating
    @hotel_price=hotel_price
    @hotel_booked=hotel_booked
    city.hotels << self
     @@all << self
  end
#-----------------------------------------------------------------
  def  self.find(id)
    @@all[id]
  end

  def self.hotel_info(id)
    hotel=self.find(id)
    puts ""
    puts "+-------------------------------------------------------------------------+".red
    puts "     #{hotel.hotel_name}\t".blue + "#{hotel.hotel_rating}\t".yellow + "#{hotel.hotel_price}\t".green + "#{hotel.hotel_booked}".green
    puts "+-------------------------------------------------------------------------+".red
    puts ""
  end
#-----------------------------------------------------------------
  def self.print
    i=1
    @@all.each do |h|
      puts "#{i}) #{h.hotel_name}"
      i+=1
    end
  end
#-----------------------------------------------------------------
def self.print_all_b
  hotel_arr=[]
@@all.each_with_index do |c,index|
  hotel_arr << c.hotel_name if c.city.name == "baghdad"  || c.city.name == "Baghdad" || c.city.name == "baghdād"
end
hotel_arr
end
# ----------------------------------------------------------------
def self.find_by_city_name(city)
  @@all.select{|h| h.city.name == city}.map{|h| h.hotel_name}
end
def self.print_all_e  # modified
  self.find_by_city_name("erbil")
#   hotel_arr=[]
# @@all.each_with_index do |c,index|
# hotel_arr << c.hotel_name if c.city.name == "erbil" || c.city.name == "Erble"
# end
# hotel_arr
end
end
#*****************************************************************
class City
  attr_accessor :name , :hotels
  @@all=[]
#-----------------------------------------------------------------
  def initialize(name)

    @name=name
    @hotels=[]
    @@all << self
    #puts "here City OBJ= #{@name}"
  end

#-----------------------------------------------------------------
end

class Cline
def start
puts "-------------------------------".yellow
puts "|   Welcome To Iraqi Hotels    |".yellow
puts "-------------------------------".yellow
puts""
puts "1) Baghdad".blue
puts "2) Erbil".blue
puts "3) Exit".blue
puts "Enter your city, please:".green
input = gets.strip.to_i

#while input !=3
if input == 2
  h_instant = Scrap.start_nokogiri("erbil")
  h_instant.each_with_index do |instant,index|   #=>  THIS LOOP FOR CREATION AN ARRAY OF INSTANTS FOR BOTH CITY & HOTEL
  instant
end

  hotel_arr = Hotel.print_all_e
  hotel_arr.each_with_index do |hotel , index|
print("#{index+1}) ")
    puts "#{hotel}".blue
  end
  puts "\n Pik a hotel number:".red
  pik_hotel = gets.strip.to_i
   Hotel.hotel_info(pik_hotel - 1)
elsif input == 1
  h_instant = Scrap.start_nokogiri("baghdad")
  h_instant.each_with_index do |instant,index|   #=>  THIS LOOP FOR CREATION AN ARRAY OF INSTANTS FOR BOTH CITY & HOTEL
  instant
  end

  hotel_arr = Hotel.print_all_b
  hotel_arr.each_with_index do |hotel , index|
  print("#{index+1}) ")
    puts "#{hotel}".blue
  end
  puts "\n Pik a hotel number:".red
  pik_hotel = gets.strip.to_i
   Hotel.hotel_info(pik_hotel - 1)
elsif input == 3
  exit
else
  exit
#end
end

end
end
Cline.new.start
# s=Scrap.new
# s.start_nokogiri("erbil")
