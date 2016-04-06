class DictionaryController < ApplicationController
  before_filter :active_tab_dictionary

  def index
    title "Chinese Dictionary - Pin1yin1.com"
  end

  def search
    @query = params[:q].to_s
    @pinyin = params[:p].to_s.downcase
    @pinyin.gsub! /[^ a-z]/, ""

    if @query != "" && params[:submit] == "Search"
      @pinyin = ""
      title @query + " - Chinese Dictionary Search - Pin1yin1.com"
      if Zi.character_is_chinese(@query[0].ord)
        @definitions = Definition.where("characters_simplified like ? or characters_traditional like ?", @query+"%", @query+"%")
      else
        ids = Definition.find_with_index(@query, {}, ids_only: true)
        @definitions = Definition.where(id: ids)
      end
    elsif @pinyin.length > 2
      @query = ""
      title @pinyin + " - Chinese Dictionary Search - Pin1yin1.com"
      @definitions = Definition.where("pinyin_ascii like ?", @pinyin+"%")
    end
  end

  def zi
    @zi = Zi.find_character(params[:c])    
    @primary_definitions = @zi.primary_definitions
    @secondary_definitions = @zi.secondary_definitions
    title @zi.character + " - Pin1yin1.com"
  end

  def radical
    if params[:c] =~ /\A[0-9]+\Z/
      radical_number = params[:c].to_i
      title "Radical #{radical_number} - Pin1yin1.com"
    else
      zi = Zi.find_character(params[:c])
      radical_number = (zi.is_radical == 0 ? zi.is_radical_simplified : zi.is_radical)
      title "Radical #{zi.character} - Pin1yin1.com"
    end

    if radical_number == 0
      raise "not a radical"
    end
    @radical_traditional = Zi.radical_zi_traditional(radical_number)    
    @radical_simplified = Zi.radical_zi_simplified(radical_number)

    @zi_list_traditional = Zi.find_by_radical(radical_number).where(:is_traditional => true).order(:strokes_after_radical)
    @zi_list_simplified = Zi.find_by_radical(radical_number).where(:is_simplified => true).order(:strokes_after_radical)
  end

  def radical_list
    @radical_list_simplified = Zi.where("is_radical != '0'").where(:is_simplified => true).order(:strokes,:radical)
    @radical_list_traditional = Zi.where("is_radical != '0'").where(:is_traditional => true).order(:strokes,:radical)
  end

private
  def active_tab_dictionary
    @active_tab = :dictionary
  end
end
