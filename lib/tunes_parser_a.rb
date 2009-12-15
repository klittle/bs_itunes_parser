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

    # Returns total library playing time in hours.
    def sum_total_playing_time
      sum_total = 0 
      self.lib.songs.each do |song|
        sum_total += (song.metadata['total_time'].to_i)/1000
      end
      ((sum_total)/3600)  #converts to hours
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
