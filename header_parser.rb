class HeaderParser
  def lookup file_name
    puts "open: #{file_name}"
    puts "header: #{header}"
    file = File.open(file_name)
    header_contents = []
    if detect_header?(file)
      header_contents = file.take_while {|l| l.start_with? comment}
      header_contents = header_contents.map { |l| l.chomp }
    end
    header_contents
  end

  def detect_header?(file)
    found = file.readline.chomp == header
    file.rewind
    found
  end

  def comment
    "# "
  end

  def header
    "#{comment}file-tagger-header:"
  end
end
