module ItunesParser
  class Song
    # A hash of info about the song, with keys such as track_id, name and artist
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
    
    # Returns a string with a simple description of the song
    def to_s_simple
        "track_id = #{@metadata['track_id']}  name = #{@metadata['name']}"
    end
    
  end
end