module ItunesParser
  class Playlist
    # A hash of info about the playlist, with keys such as playlist_id and name
    attr_accessor :metadata
    # An array of the track id's (e.g. songs, movies) in playing order  
    attr_accessor :track_ids
    
    def initialize
      @metadata = {}
      @track_ids = []
    end
    
    # Returns a string with a simple description of the playlist
    def to_s_simple
      "playlist_id = #{self.metadata['playlist_id']}  name = #{self.metadata['name']}"
    end
    
  end
end