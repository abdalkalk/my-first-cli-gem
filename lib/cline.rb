require_relative "./city.rb"
require_relative "./hotel.rb"
require_relative "./scrap.rb"
require 'colorize'

class Cline
  CITY=["baghdad","erbil"]
def start
puts "+-----------------------------------+".yellow
puts "|   Welcome To Iraqi Hotels !!!     |".yellow
puts "+-----------------------------------+".yellow
puts""
puts "1) Baghdad".blue
puts "2) Erbil".blue
puts "3) Exit".blue
puts "Enter your city number, please:".green
input = gets.strip.to_i
if input == 3
  exit
else
while input != 3
if input == 2
  hotel_list(input)
     start
elsif input == 1
  hotel_list(input)
    start
else
  start
end
end
end

end
def hotel_list(input)
  Scrap.start_nokogiri(CITY[input-1]).each do |instant|   #=>  THIS LOOP FOR CREATION AN ARRAY OF INSTANTS FOR BOTH CITY & HOTEL
   instant
 end
 Hotel.find_by_city_name(CITY[input-1]).each_with_index do |hotel , index|
 print("#{index+1}) ")
     puts "#{hotel}".blue
   end
   print "\n\n Pik a hotel number:".green
   pik_hotel = gets.strip.to_i
  if ckeck_input(pik_hotel,input)
    Hotel.hotel_info(pik_hotel - 1)
  else
    puts "Wrong input please try again.".red
  end
end
def ckeck_input(pik_hotel,input)
  pik_hotel.between?(0,Scrap.start_nokogiri(CITY[input-1]).size)
end
end
Cline.new.start
