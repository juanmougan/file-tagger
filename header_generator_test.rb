require 'minitest/autorun'
require_relative 'header_generator'

class HeaderGeneratorTest < Minitest::Test
  def test_given_hash_when_serialize_commented_keywords_then_return_yaml_string_prepended_by_comments
    header_generator = HeaderGenerator.new
    yaml = header_generator.serialize_commented_keywords valid_keywords_structure
    assert yaml != nil
    #assert yaml == "# ---\n# file-tagger-header:\n# - arrays\n# - sorting"
    # TODO if I use the assertion above, I need to adap the parser too
    assert yaml == "file-tagger-header:\n# - arrays\n# - sorting"
  end

  def test_given_keywords_structure_and_file_when_create_or_update_header_then_prepend_file_with_keywords
    header_generator = HeaderGenerator.new
  end

  def valid_keywords_structure
    keywords = ["arrays", "sorting"]
    {"file-tagger-header" => keywords}
  end
end
