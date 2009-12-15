module ItunesParser
  class Song
    attr_accessor :metadata, :playlistmetadata
    
    def initialize
      @metadata = {}
      @playlistmetadata = {}
    end
    
    def to_s_simple
        "track id = #{@metadata['track id']}  name = #{@metadata['name']}"
    end
    
    
  end
end