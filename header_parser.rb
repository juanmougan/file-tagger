require 'yaml'

class HeaderParser
  def parse file_name
    header_contents = lookup file_name
    YAML.load(header_contents.join "\n")
  end
  
  def lookup file_name
    file = File.open(file_name)
    header_contents = []
    if detect_header?(file)
      header_contents = select_comments_until_comment_end file
      header_contents = remove_newlines header_contents
      header_contents = strip_comments_from_line_start header_contents
    end
    header_contents
  end

  # TODO if this becomes a Template Method, other implementations (e.g. Java) may differ
  def select_comments_until_comment_end file
    file.take_while {|l| l.start_with? comment}
  end

  def remove_newlines lines
    lines.map { |l| l.chomp }
  end

  def strip_comments_from_line_start lines
    lines.map { |l| strip_comment_token l }
  end

  def detect_header?(file)
    found = file.readline.chomp == header
    file.rewind     # I don't want to move the pointer
    found
  end

  def comment
    "# "
  end

  def header
    "#{comment}file-tagger-header:"
  end

  def strip_comment_token line
    line = line.reverse.chomp(comment.reverse).reverse
    line = line.reverse.chomp(comment.strip.reverse).reverse
    line
  end
end
