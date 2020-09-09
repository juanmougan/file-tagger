require 'minitest/autorun'
require_relative 'header_parser'
require_relative 'files/valid_header'
require_relative 'files/class_with_valid_header'

class HeaderParserTest < Minitest::Test
  def test_given_existing_file_with_valid_header_when_lookup_then_return_the_header
    header_parser = HeaderParser.new
    file_contents = header_parser.lookup("files/class_with_valid_header.rb")
    assert file_contents != nil
    refute_empty file_contents
    puts "file_contents: #{file_contents}"
    assert file_contents[0] == "file-tagger-header:"
  end

  def test_given_file_with_header_when_detect_header_then_return_true
    header_parser = HeaderParser.new
    valid_file = File.open('files/valid_header.rb')
    assert header_parser.detect_header?(valid_file)
  end

  def given_parser_when_header_then_return_it
    header_parser = HeaderParser.new
    assert header_parser.header == "# file-tagger-header:"
  end
end