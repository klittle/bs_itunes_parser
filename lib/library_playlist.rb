#NOTE: NOT USING THIS FILE -- TRYING TO FIX PLAYLIST_PARSER.RB TO PARSE PLAYLIST
#DATA - MAY NEED TO COME BACK TO THIS


require 'active_support'
require 'nokogiri'
require 'song'

module ItunesParser
  class LibraryPlaylist

    attr_accessor :playlists

    def initialize
      # instance variable @playlist array
      @playlist = []
    end

    def parse_playlist
      #results hash
      results_playlist = {}
      
      doc     = Nokogiri::XML(File.read '/Users/klittle/documents/RubyUW/itunesprojects/bs_itunes_parser/test/test_library.xml')
      
      version = doc.xpath('/plist/dict/string[1]')[0]

      first_playlist = doc.xpath('/plist/dict/array/dict[1]/key')

      # add key-value pair to results hash.  Ref Thomas pg 46
      results_playlist['first_playlist'] = 
      # inject method Ref Thomas pg 52-53
      first_playlist.inject({}) do |playlist_info, key|
        # add key-value pair to song_info hash.
        playlist_info[key.content.downcase.underscore] = key.next.content
        playlist_info
      end

      all_playlists = doc.xpath("/plist/dict/array/dict")

      # In results hash, set key 'songs' to empty array.  Ref Thomas pg 46        
      results_playlist['playlists'] = []

      all_playlists.each do |track|
        
        playlistmetadata = {}
        playlist = Playlist.new
        
        track.xpath('./key').each do |key|
          playlist.playlistmetadata[key.content.downcase.underscore] = key.next.content
        end
        
        # The results hash 'songs' key has an array for its value.  Append song to the array.
        results_playlist['playlists'] << playlist
      end

      results_playlist['version'] = version.content

      results_playlist
    end
  end
end