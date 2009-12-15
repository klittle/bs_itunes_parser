module ItunesParser
  class Playlist
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
    
    def to_s_simple
        "playlist_id = #{@metadata['playlist_id']}  name = #{@metadata['name']}"
    end
    
    
  end
end