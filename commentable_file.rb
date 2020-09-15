module CommentableFile
  # TODO this should be moved to a Ruby implementation
  # since Java (e.g.) will have "// " instead
  def comment
    "# "
  end
  
  def forward_file_pointer_after_header file
    if detect_header?(file)
      took = select_comments_until_comment_end file
      file.rewind
      skip_n_lines_from took.size, file
    end
    file
  end

  def detect_header?(file)
    found = file.readline.chomp == header
    file.rewind     # I don't want to move the pointer
    found
  end

  def header
    "#{comment}file-tagger-header:"
  end

  # TODO if this becomes a Template Method, other implementations (e.g. Java) may differ
  # ... or maybe not? (only the comment() method changes)
  def select_comments_until_comment_end file
    file.take_while {|l| l.start_with? comment}
  end

  def skip_n_lines_from n, file
    n.times.map { file.readline }
  end
end
