class BadWords
  BAD_WORDS=File.read(Rails.root+'config'+'bad_words.txt').split

  def self.match?(s)
    BAD_WORDS.each do |word|
      return true if s =~ /#{word}/i
    end
  end
end
