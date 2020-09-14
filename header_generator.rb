require 'yaml'
require 'date'
require_relative 'commentable_file'

class HeaderGenerator include CommentableFile
  def serialize_commented_keywords keywords_structure
    keywords_structure.to_yaml.split("\n").map { |l| l.prepend "# " }.join("\n")
  end

  def create_or_update_header(file_maybe_with_header, header)
    # TODO maybe use Strings instead?
    #file_with_new_header = Tempfile.new(File.basename(file_maybe_with_header))
    #puts "header: #{header}"
    
    #file_with_new_header = Tempfile.create { |temp_file|
    #  temp_file << header
    #  content_without_header = get_file_content_skipping_header file_maybe_with_header
    #  puts "content_without_header: #{content_without_header}"
    #  temp_file << content_without_header
    #}

    file_with_new_header = Tempfile.new(File.basename(file_maybe_with_header))
    file_with_new_header << header
    content_without_header = get_file_content_skipping_header file_maybe_with_header
    #puts "content_without_header: #{content_without_header}"
    file_with_new_header << "\n" << content_without_header
    file_with_new_header.rewind
    #puts "rewinded file_with_new_header: #{file_with_new_header.read}"
    
    #file_with_new_header.write header
    # TODO read from original file (but ignore header if present!) and write to tempfile
    #File.write('some-file.txt', 'here is some text', File.size('some-file.txt'), mode: 'a')
    #file_with_new_header.write content_without_header
    # TODO read tempfile, write to original file
    FileUtils.mv file_with_new_header.path, file_maybe_with_header.path
    #puts "file_with_new_header: #{file_with_new_header.readlines}"
    #puts "file_maybe_with_header: #{file_maybe_with_header.readlines}"
    file_with_new_header
  end

  def get_file_content_skipping_header file_with_header
    file_without_header = forward_file_pointer_after_header file_with_header
    file_without_header.map {|l| l.chomp }.join("\n")
  end
end
