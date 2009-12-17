require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'

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
        # a_key must match exactly.
        # a_value will match songs that include the string "a_value", and is case insensitive.
        # Sample:  find_songs_for_key_value('artist', 'ryso') finds songs by "Peabo Bryson"


    def find_songs_for_key_value(a_key, a_value)
      
      songs_for_key_value = self.lib.songs.find_all do |song|
        #skip song if it has a nil value.  Otherwise string methods downcase and include would fail
        if (song.metadata[a_key]  != nil)
          song.metadata[a_key].downcase.include?(a_value.downcase)
        end
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
      # Returns an array for which block is not false
      songs_for_song_name = self.lib.songs.find_all do |song|
        song.metadata['name'] == song_name 
      end

      track_ids_for_song_name = songs_for_song_name.collect do |song|
        song.metadata['track_id']
      end      
      puts track_ids_for_song_name
      track_ids_for_song_name 
    end

    # Returns array of playlist id for a song
    def find_playlists_for_song(song_name)
      track_array = self.find_track_ids_for_song_name(song_name)
      # This array contains matching playlists id for track_ids
      matching_playlists_array = []
      # Enumerate through each track id for the song name   
      track_array.each do |a_track_id|

        # Enumerate through playlists
        self.lib.playlists.each_value do |playlist|
          if playlist.track_ids.include?(a_track_id)
            matching_playlists_array << playlist.metadata['playlist_id']
          end
        end         
      end        
      puts matching_playlists_array
      matching_playlists_array
    end

    # Returns an array of the names of songs most recently modified
    def find_recent_songs
      songs_with_date_modified_pair = self.lib.songs.reject do |song|
        (!song.metadata.has_key?('date_modified')) or (song.metadata['date_modified'] == nil)
      end

      songs_by_date_modified = songs_with_date_modified_pair.sort do |a, b| 
        b.metadata['date_modified'] <=> a.metadata['date_modified']
      end

      songs_first = songs_by_date_modified.first(3)
      song_names = songs_first.collect {|song| song.metadata['name']}   
    end

    # Returns an array of the name of the Top 5 played songs based on play count value
    def find_most_played_songs
      top_songs_with_play_count_pair = self.lib.songs.reject do |song|
        #this line is describing records it will get rid of
        (!song.metadata.has_key?('play_count')) or (song.metadata['play_count'] == nil)
      end

      top_songs_played_sorted = top_songs_with_play_count_pair.sort do |a, b| 
        b.metadata['play_count'].to_i <=> a.metadata['play_count'].to_i
      end

      top_songs_played = top_songs_played_sorted.first(5)
      song_names_of_top_played = top_songs_played.collect {|song| song.metadata['name']}   
    end


  end # TunesParserA

end # ITunesParser