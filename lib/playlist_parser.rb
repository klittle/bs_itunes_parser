#NOTE:  This is the file Ben wrote in class on Wed. to parse data from the Playlist info out of the iTunes File
#I made it a separate method to see if I could get it to work before I put it in the bigger program
#I have it directly reading my itunesfile -- it is not running through the test program
#I call it directly in irb with ruby playlist_parser.rb
#It puts the stuff to the screen, but I think it is crashing at line 47-48
#Message I get is:  playlist_parser.rb:12:in `parse_playlist': undefined local variable or method `playlist_xml' for main:Object (NameError)
#from playlist_parser.rb:47
#I tried putting name=playlist_xml.xpath right after the xml=Nokogiri.XML, but it doesn't seem to change anything
#I don't really understand why line 21 is not playlist_dicts = playlist_xml.xpath
#I tried changing it to that but it doesn't change anything.
#Can you help?  Thanks


#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'


def parse_playlist
  xml = Nokogiri.XML( File.read "/Users/klittle/documents/RubyUW/itunesprojects/bs_itunes_parser/test/test_library.xml")

  
  playlist_dicts = xml.xpath( "/plist/dict/array/dict" )
  
  playlist_dicts.each do |playlistxml|
    name = playlist_xml.xpath( "./key[text()='Name']" ).first.next_sibling.content
    puts "Found playlist called '#{name}'"

    if visible = playlist_xml.xpath( "./key[text()='Visible']" )
      unless visible.empty?
        puts "- skipping; invisible"
        next
      end
    end

    if distinguished_kind = playlist_xml.xpath(
      "./key[text()='Distinguished Kind']" )
      unless distinguished_kind.empty?
        puts "- skipping; has a distinguished kind"
        next
      end
    end

    if smart_info = playlist_xml.xpath( "./key[text()='Smart Info']" )
      unless smart_info.empty?
        puts "- skipping; has smart info"
        next
      end
    end


    # we have something we want now
    tracks = playlist_xml.xpath( "array[1]//integer" )
    puts tracks.map {|t| t.content }
 end
end

parse_playlist
