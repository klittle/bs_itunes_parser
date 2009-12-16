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
      self.lib.playlists.each_value do |playlist|
        puts playlist.to_s_simple
      end
    end

    def find_track_ids_for_song_name(song_name)
      #returns an array for which block is not false
      songs_for_song_name = self.lib.songs.find_all do |song|
        song.metadata['name'] == song_name 
      end

      track_ids_for_song_name = songs_for_song_name.collect do |song|
        song.metadata['track_id']
      end      
      puts track_ids_for_song_name
      track_ids_for_song_name 
    end

    # returns array of playlist id for a song
    def find_playlists_for_song(song_name)
      track_array = self.find_track_ids_for_song_name(song_name)
      # this array contains matching playlists id for track_ids
      matching_playlists_array = []
      # enumerate through each track id for the song name   
      track_array.each do |a_track_id|

        # enumerate through playlists
        self.lib.playlists.each_value do |playlist|
          if playlist.track_ids.include?(a_track_id)
            matching_playlists_array << playlist.metadata['playlist_id']
          end
        end         
      end        
      puts matching_playlists_array
      matching_playlists_array
    end


  end # TunesParserA

end # ITunesParser