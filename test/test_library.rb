# in Terminal, open main project folder (e.g. bs_itunes_parser), then run autotest.

require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'library'
$LOAD_PATH.unshift(File.dirname(__FILE__))

class TestLibrary < Test::Unit::TestCase
  should "create a new object" do
    library = ItunesParser::Library.new
    assert_instance_of(ItunesParser::Library, library)
  end

  context "#parse" do
    #test/testing.xml is the smaller testing file - it is one that is running
    #test/test_library.xml is larger testing file - to run it - uncomment the line
    #under set-up in test_library.rb and test_tunes_parser_a.rb
    setup do
      @lib = ItunesParser::Library.new
      
      #@itunes_xml_file_name = 'test/test_library.xml'
      @itunes_xml_file_name = 'test/testing.xml'
      @lib.parse(File.read(@itunes_xml_file_name))
    end

    should "have correct version key" do
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_equal(@lib.version, '9.0.1')
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(@lib.version, '9.0.2')
      end
    end

    should "return an array containing only Songs" do
      # assert @result['songs'].all? { |r| r.is_a?(ItunesParser::Song) }      
      assert @lib.songs.all? { |r| r.is_a?(ItunesParser::Song) }      
    end
    
    should "return an array containing Playlist tracks" do
      puts @lib.playlists['697'].track_ids
    end
     
  end
end
