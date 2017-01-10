class PinyinController < ApplicationController
  def json_string(s)
    '"'+s.gsub('"','\"').gsub("\n","\\n")+'"'
  end

  def json_join_strings(array)
    a2 = array.collect { |syllable| json_string(syllable) }
    return a2.join(",")
  end

  def convert
    @characters = (params[:c] || '')
    @conversion = Definition.convert(@characters)

    json = <<END
{
  "q": #{json_string(@characters)},
  "s": #{@conversion[:characters_simplified].inspect},
  "t": #{@conversion[:characters_traditional].inspect},
  "p": [#{json_join_strings(@conversion[:pinyin_ascii_tone])}],
  "e": [#{json_join_strings(@conversion[:english])}],
  "c": [#{@conversion[:english_character_count].join(",")}]
}
END

    render :plain => json, :content_type => "text/plain"
  end

  def form
    @active_tab = :convert
  end
end
