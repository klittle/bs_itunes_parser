require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'
require 'ostruct'

module ItunesParser

  class TunesParserA
    
    # A parsed iTunes library model
    attr_accessor :lib
    
    # Creates a new library, parses the argument, and populates the library
    def initialize(itunes_xml_file_name)   
      @lib = ItunesParser::Library.new    
      @lib.parse(File.read(itunes_xml_file_name))
    end
    
    # Returns the number of songs in the library
    def song_count
      self.lib.songs.count
    end

    # Returns a string with a simple description of the library
    # Sample: library_summary returns Summary:  library version = 9.0.2, number of songs = 52
    def library_summary
      "Summary:  library version = #{self.lib.version}, number of songs = #{self.song_count}"
    end    

    # "Puts" the simple description for each song in the library
    def list_songs 
      self.lib.songs.each do |song|
        puts song.to_s_simple
      end
    end

    # Returns an array of songs that match a_key and a_value.
      # Key and value must match library exactly. 'Bryson' will not find 'Peabo Bryson'.    
      # Sample: find_songs_for_key_value('artist', 'Peabo Bryson Regina Belle, \& David Friedman')
    def find_songs_for_key_value(a_key, a_value)
      songs_for_key_value = self.lib.songs.find_all do |song|
        song.metadata[a_key]== a_value
      end
      songs_for_key_value
    end

    # Returns an array of songs that do not contain a_key.    
    def find_songs_without_key(a_key)
      songs_without_key =  self.lib.songs.find_all do |song|
        song.metadata.has_key?(a_key) == false
      end
      songs_without_key
    end
    
    # Returns the integer number of unique values in the library for a key such as 'artist', 'album', or 'genre'. 
      # Sample: count_unique_values_for_key('album') returns 227
    def count_unique_values_for_key(a_key)
      values_array = [] #array of values
      self.lib.songs.each do |song|
        values_array << song.metadata[a_key]
      end
      unique_count = values_array.uniq.count
      puts "Unique values for key #{a_key} = #{unique_count}"
      unique_count
    end

    # Returns a struct of time components: days, hours, minutes, seconds
    def seconds_to_time_components(secs)     
      # Ref book Fulton The Ruby Way Second Edition pg 227
      # Ref http://nutrun.com/weblog/ruby-struct/
      time_components = OpenStruct.new()      
      time = secs.round                     # Round to nearest second
      
      time_components.seconds = time % 60   # Get seconds from modulo remainder
      time /= 60                            # Truncate seconds
      time_components.minutes = time % 60   # Extract minutes
      time /= 60                            # Truncate minutes
      time_components.hours = time % 24     # Extract hours
      time /= 24                            # Truncate hours
      time_components.days = time           # Days
      time_components                       # return the struct
    end

    # Returns a struct of time components for the songs in the library.  See seconds_to_time_components
    def songs_time_components
      total_songs_time = 0
      self.lib.songs.each do |song|
        total_songs_time += (song.metadata['total_time'].to_f / 1000.0)
      end
      seconds_to_time_components(total_songs_time)     
    end
    
    # Returns a string of the library playing time.
    #   Sample: library_playing_time returns "Playing time = 10:08:10:50 [dd:hh:mm:ss]"  
    def library_playing_time
      stc = self.songs_time_components
      "Playing time = %02d:%02d:%02d:%02d [dd:hh:mm:ss]" % [stc.days, stc.hours, stc.minutes, stc.seconds]
    end
    
    # Returns the number of playlists in the library
    def playlists_length
      self.lib.playlists.length
    end
    
    # "Puts" the simple description for each playlist in the library
    def list_playlists
      # hash .each method requires key-value pair in block, not key only
      self.lib.playlists.each do |playlist_id, playlist|
        puts playlist.to_s_simple
      end
    end
    
    
  end
end
