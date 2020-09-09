class HeaderParser
  def lookup file_name
    puts "open: #{file_name}"
    puts "header: #{header}"
    file = File.open(file_name)
    header_contents = []
    if detect_header?(file)
      header_contents = select_comments_until_comment_end file
      header_contents = remove_newlines header_contents
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
end
