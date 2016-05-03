weights = {
  1 => 1,
  2 => 0.5,
  3 => 0.25,
  4 => 0.1,
  5 => 0.05
}

scores = {}
Zi.where(is_simplified: true).where('frequency <> 6').each do |zi|
  next if zi.phonetic == 0
  scores[zi.phonetic] ||= 0
  scores[zi.phonetic] += weights[zi.frequency]
end

scores.keys.sort {|a,b| scores[b] <=> scores[a]}[0..99].each do |phonetic|
  examples = Zi.where(phonetic: phonetic).order(:strokes).limit(10)

  print examples.map(&:character).join(''), ' '
end
puts
