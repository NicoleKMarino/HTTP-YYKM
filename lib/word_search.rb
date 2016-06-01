class WordSearch

  def initialize(word)
    @word = word
  end

  def word_search(word = @word)
    lines = File.readlines('/usr/share/dict/words').grep(/#{word}/)
    if lines.empty?
      return "WORD is not a known word"
    else
      return "WORD is a known word"
    end
  end

end
