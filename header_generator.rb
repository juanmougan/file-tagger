require 'yaml'
require 'date'
require_relative 'commentable_file'

class HeaderGenerator include CommentableFile

  attr_accessor :file

  def initialize file_to_add_header_to
    self.file = file_to_add_header_to
  end
  
  # TODO move to module? or to a new object (for testability)?
  def serialize_commented_keywords keywords_structure
    keywords_structure.to_yaml.split("\n").map { |l| l.prepend "# " }.join("\n")
  end

  def create_or_update_header header
    file_with_new_header = Tempfile.new(File.basename(self.file))
    file_with_new_header << header
    content_without_header = get_file_content_skipping_header self.file
    file_with_new_header << "\n" << content_without_header
    file_with_new_header.rewind
    self.file = file_with_new_header
  end

  def get_file_content_skipping_header file_with_header
    file_without_header = forward_file_pointer_after_header file_with_header
    file_without_header.map {|l| l.chomp }.join("\n")
  end
end
