require 'yaml'
require 'date'
require_relative 'commentable_file'

class HeaderGenerator include CommentableFile
  def serialize_commented_keywords keywords_structure
    keywords_structure.to_yaml.split("\n").map { |l| l.prepend "# " }.join("\n")
  end

  def create_or_update_header(file_maybe_with_header, header)
    file_with_new_header = Tempfile.new(File.basename(file_maybe_with_header))
    file_with_new_header << header
    content_without_header = get_file_content_skipping_header file_maybe_with_header
    file_with_new_header << "\n" << content_without_header
    file_with_new_header.rewind
    file_with_new_header
  end

  def get_file_content_skipping_header file_with_header
    file_without_header = forward_file_pointer_after_header file_with_header
    file_without_header.map {|l| l.chomp }.join("\n")
  end
end
