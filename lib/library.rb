# need active_support for underscore method
# Note underscore converts camel case.  It doesn't replace space with underscore.
# http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html
require 'active_support'
require 'nokogiri'
require 'song'
require 'playlist'

module ItunesParser
  class Library

    attr_accessor :songs

    def initialize
      # instance variable @songs array
      @songs = []
    end

    def parse(xml)
      #results hash
      results = {}
      
      doc     = Nokogiri::XML(xml)
      
      version = doc.xpath('/plist/dict/string[1]')[0]

      all_songs = doc.xpath('/plist/dict/dict/dict')

      # In results hash, set key 'songs' to empty array.  Ref Thomas pg 46        
      results['songs'] = []

      all_songs.each do |track|
        
        song = Song.new
        
        track.xpath('./key').each do |key|
          song.metadata[key.content.downcase.underscore] = key.next.content
        end
        
        # The results hash 'songs' key has an array for its value.  Append song to the array.
        results['songs'] << song
      end

      results['version'] = version.content

      results
    end
  end
end