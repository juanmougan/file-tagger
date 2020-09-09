require 'yaml'

class HeaderGenerator
  def serialize_commented_keywords keywords_structure
    keywords_structure.to_yaml.split("\n").map { |l| l.prepend "# " }.join("\n")
  end
end
