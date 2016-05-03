weights = {
  1 => 1,
  2 => 0.5,
  3 => 0.25,
  4 => 0.1,
  5 => 0.05
}

scores = {}
Zi.where(is_simplified: true).where('frequency <> 6').each do |zi|
  scores[zi.radical] ||= 0
  scores[zi.radical] += weights[zi.frequency]
end

scores.keys.sort {|a,b| scores[b] <=> scores[a]}[0..99].each do |radical|
  zi = Zi.find_by_is_radical_simplified(radical) || Zi.find_by_is_radical(radical)
  raise "could not find radical #{radical}" if !zi

  print zi.character, ' '
end
puts
