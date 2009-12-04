require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tunes_parser_a'
$LOAD_PATH.unshift(File.dirname(__FILE__))

# *** Note:  tests run in alphabetical order, not in order of appearance! ***
class TestTunesParserA < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      puts "setup fileRead Context"
      # itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      itunes_xml_file_name = './test/test_library.xml'
      @my_tunes_parser_a = ItunesParser::TunesParserA.new(itunes_xml_file_name)
    end

    should "01 return a TunesParserA" do
      puts "test- return a TunesParserA"
      puts ""
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
    end

    should "02 list a summary" do
      puts "test- list a summary"
      puts ""
      assert_nil(@my_tunes_parser_a.list_summary)
    end

    should "03 return the number of songs" do
      puts "test- return the number of songs"
      puts ""
      assert_equal(1786, @my_tunes_parser_a.song_count)
    end

    should "04 provide correct metadata values" do
      puts "test- provide correct metadata values"
      # first song in the songs array
      first_song_in_songs = @my_tunes_parser_a.parsed_lib['songs'][0]
      puts "first song in songs = #{first_song_in_songs.inspect}"
      puts "" 
      assert_instance_of(ItunesParser::Song, first_song_in_songs)
      assert_equal("Dan Sartain", first_song_in_songs.metadata['artist'])
      assert_equal("Totem Pole", first_song_in_songs.metadata['name'])
      assert_equal("2006", first_song_in_songs.metadata['year'])
      assert_equal("MPEG audio file", first_song_in_songs.metadata['kind'])
      # size in bytes
      assert_equal("5191680", first_song_in_songs.metadata['size'])
      # sample rate in Hz
      assert_equal("44100", first_song_in_songs.metadata['sample rate'])
      # total time in msec
      assert_equal("180035", first_song_in_songs.metadata['total time'])

      # "first_song" in hash is a hash
      assert_instance_of(Hash, @my_tunes_parser_a.parsed_lib['first_song'])      
    end

    should "05 last song is a song" do
      puts "test- last song is a song"
      puts ""
      index_of_last_song = (@my_tunes_parser_a.song_count - 1)
      last_song = @my_tunes_parser_a.parsed_lib['songs'][index_of_last_song]
      puts "last song = #{last_song.inspect}"
      assert_instance_of(ItunesParser::Song, last_song)
    end

    # should "06 list songs" do
    #   puts "test- list songs"
    #   @my_tunes_parser_a.list_songs
    #   assert_not_nil(true)
    #   puts ""
    # end 

    should "11 find songs for artist" do
      puts "test- find songs for artist"
      result = @my_tunes_parser_a.find_songs_for_artist
      result.each do |song|
        song.to_s_simple
      end
      assert_equal(8, result.count)
    end

    should "12 find songs for key value" do
      puts "test- find songs for key value"
      assert_equal(8, @my_tunes_parser_a.find_songs_for_key_value('artist', 'Cause4Concern').count)
      assert_equal(41, @my_tunes_parser_a.find_songs_for_key_value('year', '2001').count)
    end

    should "13 count unique values for key" do
      puts "test- count unique values for key"
      assert_equal(237, @my_tunes_parser_a.count_unique_values_for_key('artist'))
      assert_equal(1786, @my_tunes_parser_a.count_unique_values_for_key('track id'))
      assert_equal(227, @my_tunes_parser_a.count_unique_values_for_key('album'))
    end

  end

end
