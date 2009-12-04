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
    setup do
      @lib = ItunesParser::Library.new
      @result = @lib.parse(File.read('test/test_library.xml'))
    end

    should "return a Hash" do
      assert_instance_of(Hash, @result)
    end
    
    should "have a version key" do
      assert_equal(@result['version'], '9.0.1')
    end
    
    should "find the first song with the appropriate name" do
      assert_equal(@result['first_song']['name'], 'Totem Pole')
    end
    
    should "give us an array of Songs" do
      assert @result['songs'].all? { |r| r.is_a?(ItunesParser::Song) }      
    end
  end
end
