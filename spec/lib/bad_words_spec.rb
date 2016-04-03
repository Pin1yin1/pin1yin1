require_relative "../spec_helper.rb"

describe BadWords do
  describe "match?" do
    before do
      allow(BadWords).to receive(:bad_words_list) { ['foobar', 'fubar'] }
    end

    ['befoobar','fubared','FOObar'].each do |word|
      it "returns true for '#{word}'" do
        expect(BadWords.match?(word)).to eq true
      end
    end
  end
end
