class WordSearch

  def word_search(word)
    lines = File.readlines('/usr/share/dict/words').grep(/#{word}/)
    if lines.empty?
      return "#{word} is not a known word"
    else
      return "#{word} is a known word"
    end
  end

end
