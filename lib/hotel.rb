require_relative "./city.rb"
require_relative "./cline.rb"
require 'colorize'
require_relative "./scrap.rb"
class Hotel
  @@all=[]
   attr_accessor :hotel_name,:city,:hotel_rating,:hotel_booked,:hotel_details
#-----------------------------------------------------------------
   def initialize(hotel_name,city,hotel_rating,hotel_booked,hotel_details)
    @hotel_name=hotel_name
    self.city=city
    @hotel_rating=hotel_rating
    @hotel_booked=hotel_booked
    @hotel_details=hotel_details
    city.hotels << self
     @@all << self
  end
#-----------------------------------------------------------------
def self.clear_all
  @@all.clear
end
  def  self.find(id)
    @@all[id]
  end

  def self.hotel_info(id)
    hotel=self.find(id)
    puts ""
    puts "+-------------------------------------------------------------------------+".red
    puts "    Name: #{hotel.hotel_name}\t".blue +     "Rate:""#{hotel.hotel_rating}".blue
    puts "    Details: #{hotel.hotel_details}".green
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
def self.find_by_city_name(city)
  @@all.select{|h| h.city.name == city || h.city.name == "baghdād"}.map{|h| h.hotel_name}
end

end
#*****************************************************************
