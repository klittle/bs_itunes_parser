# in Terminal, open main project folder (e.g. bs_itunes_parser), then run autotest.
#kpl note - this doesn't work - it is already being done but not to new file
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
  end
end
