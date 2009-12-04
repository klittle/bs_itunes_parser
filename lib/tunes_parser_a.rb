require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'

module ItunesParser

  class TunesParserA

    # parsed_lib is a hash
    attr_accessor :parsed_lib

    def initialize(itunes_xml_file_name)   
      @lib = ItunesParser::Library.new    
      @parsed_lib = @lib.parse(File.read(itunes_xml_file_name))
    end

    def song_count
      @song_count = parsed_lib['songs'].count
    end

    def list_summary
      puts "library version #{parsed_lib['version']}"
      puts "number of songs #{self.song_count}"
    end    

    def list_first_song
      puts parsed_lib['first_song'].inspect
      puts "first song's class #{parsed_lib['first_song'].class}"
      puts "first song's name #{parsed_lib['first_song']['name']}"
      puts "first song's artist #{parsed_lib['first_song']['artist']}"
      puts "first song's year #{parsed_lib['first_song']['year']}"
      puts "first song's kind #{parsed_lib['first_song']['kind']}"
      puts "first song's size #{parsed_lib['first_song']['size']} bytes"
      # Note: these tags don't have underscore inserted
      puts "first song's sample rate #{parsed_lib['first_song']['sample rate']} Hz"
      puts "first song's total time #{parsed_lib['first_song']['total time']} millisec"
    end

    def list_songs 
      parsed_lib['songs'].each do |song|
        song.to_s_simple
      end
    end
 
    def find_songs_for_artist
      songs_for_artist = parsed_lib['songs'].find_all do |song|
        song.metadata['artist']=='Cause4Concern'
      end
      songs_for_artist
    end
    
    def find_songs_for_key_value(a_key, a_value)
      songs_for_key_value = parsed_lib['songs'].find_all do |song|
        song.metadata[a_key]== a_value
      end
      songs_for_key_value
    end

    def count_unique_values_for_key(a_key)
      values_array = [] #array of values
      parsed_lib['songs'].each do |song|
        values_array << song.metadata[a_key]
      end
      puts values_array.uniq.count
      values_array.uniq.count
    end
   
  end

end
