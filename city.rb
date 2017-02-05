# require "./city"
require_relative "./cline.rb"
require_relative "./hotel.rb"
require_relative "./scrap.rb"
require 'colorize'
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
def self.clear_all
  @@all.clear
end
#-----------------------------------------------------------------
end
