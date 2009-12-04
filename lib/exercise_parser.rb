require 'tunes_parser_a'

class ExerciseParser

  itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'

  my_tunes_parser_a = ItunesParser::TunesParserA.new(itunes_xml_file_name)

    my_tunes_parser_a.list_summary
    my_tunes_parser_a.list_first_song
    my_tunes_parser_a.list_song(0)
    my_tunes_parser_a.list_song(1)    
    my_tunes_parser_a.list_song(2)  
    #my_tunes_parser_a.populate_metadata


end