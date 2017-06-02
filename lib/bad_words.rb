class BadWords
  def self.bad_words_list
    @bad_words_list ||= if ENV['PIN1YIN1_BAD_WORDS_FILE']
                          File.read(ENV['PIN1YIN1_BAD_WORDS_FILE']).split
                        else
                          []
                        end
  end

  def self.match?(s)
    bad_words_list.any? do |word|
      s =~ /#{word}/i
    end
  end
end
