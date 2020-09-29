require 'minitest/autorun'
require 'tempfile'
require_relative 'header_generator'

class HeaderGeneratorTest < Minitest::Test
  attr_accessor :file_without_header
  attr_accessor :file_with_header

  def setup
    without_header_template_file = "files/class_without_header.rb"
    self.file_without_header = Tempfile.new('file_without_header.rb')
    File.open(without_header_template_file, 'r') do |input_stream|
      File.open(file_without_header, 'w') do |output_stream|
        IO.copy_stream(input_stream, output_stream)
      end
     end
    
    # TODO remove this duplication
    with_header_template_file = "files/class_with_valid_header.rb"
    self.file_with_header = Tempfile.new('file_with_header.rb')
    File.open(with_header_template_file, 'r') do |input_stream|
      File.open(file_with_header, 'w') do |output_stream|
        IO.copy_stream(input_stream, output_stream)
      end
     end
  end

  def teardown
    self.file_without_header.unlink
    self.file_with_header.unlink
  end
  
  # TODO add "test" prefix to the name, then fix
  def given_hash_when_serialize_commented_keywords_then_return_yaml_string_prepended_by_comments
    header_generator = HeaderGenerator.new
    # TODO maybe this is a public method of another object?
    yaml = header_generator.serialize_commented_keywords valid_keywords_structure
    assert yaml != nil
    assert yaml == "# ---\n# file-tagger-header:\n# - arrays\n# - sorting"
    # TODO if I use the assertion above, I need to adapt the parser too
    #assert yaml == "file-tagger-header:\n# - arrays\n# - sorting"
  end

  def test_given_keywords_structure_and_file_when_create_or_update_header_then_prepend_file_with_keywords
    header_generator = HeaderGenerator.new(self.file_without_header)
    header = header_generator.serialize_commented_keywords valid_keywords_structure
    file_with_header = header_generator.create_or_update_header header
    assert file_starts_with(file_with_header, header)
  end

  def test_given_keywords_structure_and_file_with_header_when_create_or_update_header_then_generate_header_with_all_keywords
    header_generator = HeaderGenerator.new(self.file_without_header)
    header = header_generator.serialize_commented_keywords(valid_keywords_structure(["arrays", "sorting", "prefix sums"]))
    file_with_header = header_generator.create_or_update_header header
    #puts "self.file_without_header: #{self.file_without_header.path}"
    #puts "self.file_without_header: #{header_generator.file.path}"
    assert self.file_without_header.path == header_generator.file.path  # FIXME make sure the same path is used
    assert file_starts_with(file_with_header, header)
    assert file_content_are_the_same(header_generator, file_with_header, self.file_without_header)
  end

  def file_starts_with(file, beginning)
    #"# ---\n# file-tagger-header:\n# - arrays\n# - sorting"
    commented_lines = file.take_while {|l| l.start_with? "# "}.map {|l| l.chomp}  # TODO move constants to a module
    beginning_lines = beginning.split("\n")
    commented_lines == beginning_lines
  end

  def file_content_are_the_same(header_generator, file_with_header, original_file)
    forwarded_file_with_header_content = header_generator.get_file_content_skipping_header file_with_header
    forwarded_original_file_content = header_generator.get_file_content_skipping_header original_file
    forwarded_file_with_header_content == forwarded_original_file_content
  end

  def valid_keywords_structure(keywords = ["arrays", "sorting"])
    {"file-tagger-header" => keywords}
  end

  def valid_header
    #"# ---\n# file-tagger-header:\n# - arrays\n# - sorting"
    ["# ---", "# file-tagger-header:", "# - arrays", "# - sorting"]
  end
end
