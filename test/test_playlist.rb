# require 'helper'
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
# require 'playlist'
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# 
# # *** Note:  tests run in alphabetical order, not in order of appearance! ***
# class TestPlaylist < Test::Unit::TestCase
# 
#   context "#fileRead" do  
#       
#     setup do
#       a_playlist = Playlist.new
#       a_playlist.metadata['name'] = 'George'
#     end
# 
#     should "01 return a playlist" do
#       puts "test- return a playlist"
#       assert_instance_of(ItunesParser::Playlist, a_playlist)
#     end
# 
#     should "02 return a name" do
#       puts "test- return a name"
#       assert_equal('George', a_playlist.metadata['name'])
#     end
# 
# 
#   end
# end
