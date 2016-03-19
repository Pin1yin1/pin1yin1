require_relative "../spec_helper.rb"

describe BadWords do
  describe "match?" do
    ['sextant','middlesex','sEx'].each do |word|
      it "returns true for '#{word}'" do
        expect(BadWords.match?(word)).to eq true
      end
    end
  end
end
