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
    assert file_contents[0] == "file-tagger-header:"
  end

  def test_given_file_with_header_when_detect_header_then_return_true
    header_parser = HeaderParser.new
    valid_file = File.open('files/valid_header.rb')
    assert header_parser.detect_header?(valid_file)
  end

  def test_given_parser_when_header_then_return_it
    header_parser = HeaderParser.new
    assert header_parser.header == "# file-tagger-header:"
  end

  def test_given_string_when_strip_comment_token_then_return_stripped_string
    header_parser = HeaderParser.new
    assert header_parser.strip_comment_token("# blah") == "blah"
    assert header_parser.strip_comment_token("#bang!") == "bang!"
    assert header_parser.strip_comment_token("boo#") == "boo#"
  end

  def test_given_file_with_header_when_parse_then_return_header
    header_parser = HeaderParser.new
    header = header_parser.parse("files/class_with_valid_header.rb")
    assert header != nil
    assert header["file-tagger-header"] != nil
    assert header["file-tagger-header"]["keywords"] != nil
    assert header["file-tagger-header"]["keywords"][0] == "arrays"
    assert header["file-tagger-header"]["keywords"][1] == "sorting"
  end

  # TODO this belongs to the module now, let's move it
  def test_given_file_with_valid_header_when_forward_file_pointer_after_header_then_return_next_line
    header_parser = HeaderParser.new
    valid_header_file = "files/class_with_valid_header.rb"
    file_with_header = header_parser.forward_file_pointer_after_header File.open(valid_header_file, 'r')
    assert file_with_header.readline.chomp == "class Valid"
  end

  def test_given_file_without_header_when_forward_file_pointer_after_header_then_return_next_line
    header_parser = HeaderParser.new
    without_header_file = "files/class_without_header.rb"
    file_without_header = header_parser.forward_file_pointer_after_header File.open(without_header_file, 'r')
    assert file_without_header.readline.chomp == "class Without"
  end
end
