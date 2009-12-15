require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tunes_parser_a'
$LOAD_PATH.unshift(File.dirname(__FILE__))

# *** Note:  tests run in alphabetical order, not in order of appearance! ***
class TestTunesParserA < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      puts "setup fileRead Context"
      # @itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      # @itunes_xml_file_name = 'test/test_library.xml'
      @itunes_xml_file_name = 'test/testing.xml'
      @my_tunes_parser_a = ItunesParser::TunesParserA.new(@itunes_xml_file_name)
    end

    should "01 return a TunesParserA" do
      puts "test- return a TunesParserA"
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
    end

    should "02 return a string library summary" do
      puts "test- return a string library summary"
      puts @my_tunes_parser_a.library_summary
      assert_instance_of(String, @my_tunes_parser_a.library_summary)
    end

    should "03 return the number of songs" do
      puts "test- return the number of songs"
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_equal(1786, @my_tunes_parser_a.song_count)
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(52, @my_tunes_parser_a.song_count)
      end
    end

    should "04 provide correct metadata values" do
      puts "test- provide correct metadata values"
      # first song in the songs array
      first_song_in_songs = @my_tunes_parser_a.lib.songs[0]
      puts "first song in songs = #{first_song_in_songs.inspect}"
      puts "" 
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_instance_of(ItunesParser::Song, first_song_in_songs)
        assert_equal("Dan Sartain", first_song_in_songs.metadata['artist'])
        assert_equal("Totem Pole", first_song_in_songs.metadata['name'])
        assert_equal("2006", first_song_in_songs.metadata['year'])
        assert_equal("MPEG audio file", first_song_in_songs.metadata['kind'])
        # size in bytes
        assert_equal("5191680", first_song_in_songs.metadata['size'])
        # sample rate in Hz
        assert_equal("44100", first_song_in_songs.metadata['sample_rate'])
        # total time in msec
        assert_equal("180035", first_song_in_songs.metadata['total_time'])
      end

      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_instance_of(ItunesParser::Song, first_song_in_songs)
        assert_equal("Bruce Adler", first_song_in_songs.metadata['artist'])
        assert_equal("Arabian Nights", first_song_in_songs.metadata['name'])
        assert_equal("1992", first_song_in_songs.metadata['year'])
        assert_equal("MPEG audio file", first_song_in_songs.metadata['kind'])
        # size in bytes
        assert_equal("1898624", first_song_in_songs.metadata['size'])
        # sample rate in Hz
        assert_equal("44100", first_song_in_songs.metadata['sample_rate'])
        # total time in msec
        assert_equal("79725", first_song_in_songs.metadata['total_time'])
      end

    end

    should "05 last song is a song" do
      puts "test- last song is a song"
      puts ""
      index_of_last_song = (@my_tunes_parser_a.song_count - 1)
      last_song = @my_tunes_parser_a.lib.songs[index_of_last_song]
      puts "last song = #{last_song.inspect}"
      assert_instance_of(ItunesParser::Song, last_song)
    end

    # should "06 list songs" do
    #   puts "test- list songs"
    #   @my_tunes_parser_a.list_songs
    #   assert_not_nil(true)
    #   puts ""
    # end 

    should "10 return a string describing song" do
      puts "test- return a string describing song"
      a_song = @my_tunes_parser_a.lib.songs[6]
      puts a_song.to_s_simple
      assert_instance_of(String, a_song.to_s_simple)
    end

    should "12 find songs for key value" do
      puts "test- find songs for key value"
      if @itunes_xml_file_name == 'test/test_library.xml'       
        assert_equal(8, @my_tunes_parser_a.find_songs_for_key_value('artist', 'Cause4Concern').count)
        assert_equal(41, @my_tunes_parser_a.find_songs_for_key_value('year', '2001').count)
      end

      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "Peabo Bryson Regina Belle, \& David Friedman").count)
        assert_equal(21, @my_tunes_parser_a.find_songs_for_key_value('year', '1992').count)
      end
    end

    should "13 count unique values for key" do
      puts "test- count unique values for key"
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_equal(1786, @my_tunes_parser_a.count_unique_values_for_key('track_id'))
        assert_equal(237, @my_tunes_parser_a.count_unique_values_for_key('artist'))
        assert_equal(227, @my_tunes_parser_a.count_unique_values_for_key('album'))
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(52, @my_tunes_parser_a.count_unique_values_for_key('track_id'))
        assert_equal(7, @my_tunes_parser_a.count_unique_values_for_key('artist'))
        assert_equal(2, @my_tunes_parser_a.count_unique_values_for_key('album'))
      end
    end

    should "14 convert seconds to time components" do
      puts "test- convert seconds to time components"
      assert_equal(0, @my_tunes_parser_a.seconds_to_time_components(0).seconds)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(24*60*60).days)
      test_secs = 3662
      assert_equal(2, @my_tunes_parser_a.seconds_to_time_components(test_secs).seconds)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(test_secs).minutes)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(test_secs).hours)
      assert_equal(0, @my_tunes_parser_a.seconds_to_time_components(test_secs).days)      
    end

    should "15 return library songs time components" do
      puts "test- library songs time components"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(10, @my_tunes_parser_a.songs_time_components.days)
        assert_equal(8, @my_tunes_parser_a.songs_time_components.hours)
        assert_equal(10, @my_tunes_parser_a.songs_time_components.minutes)
        assert_equal(50, @my_tunes_parser_a.songs_time_components.seconds) 
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(0, @my_tunes_parser_a.songs_time_components.days)
        assert_equal(1, @my_tunes_parser_a.songs_time_components.hours)
        assert_equal(48, @my_tunes_parser_a.songs_time_components.minutes)
        assert_equal(13, @my_tunes_parser_a.songs_time_components.seconds) 
      end
    end

    should "16 return library playing time" do
      puts "test- library playing time"
      puts @my_tunes_parser_a.library_playing_time
      #  TODO: this answer seems about double expected.
      #  are we double counting due to albums?  Duplicate songs with different sample rates?
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal("Playing time = 10:08:10:50 [dd:hh:mm:ss]", @my_tunes_parser_a.library_playing_time)
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal("Playing time = 00:01:48:13 [dd:hh:mm:ss]", @my_tunes_parser_a.library_playing_time)
      end
    end


    should "18 find songs without key" do
      puts "test- find songs without key"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(302, @my_tunes_parser_a.find_songs_without_key('album').count)
        assert_equal(542, @my_tunes_parser_a.find_songs_without_key('genre').count)
        assert_equal(@my_tunes_parser_a.song_count, @my_tunes_parser_a.find_songs_without_key('key_without_match').count)
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(0, @my_tunes_parser_a.find_songs_without_key('album').count)
        assert_equal(31, @my_tunes_parser_a.find_songs_without_key('comments').count)
        assert_equal(@my_tunes_parser_a.song_count, @my_tunes_parser_a.find_songs_without_key('key_without_match').count)
      end
    end

    should "30 return the number of playlists" do
      puts "test- return the number of playlists"
      @my_tunes_parser_a.list_playlists
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_equal(36, @my_tunes_parser_a.playlists_length)
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(2, @my_tunes_parser_a.playlists_length)
      end
    end

    should "31 return a playlist" do
      puts "test- return a playlist"
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_instance_of(ItunesParser::Playlist, @my_tunes_parser_a.lib.playlists['9416'])
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_instance_of(ItunesParser::Playlist, @my_tunes_parser_a.lib.playlists['697'])
      end
    end


  end
end
