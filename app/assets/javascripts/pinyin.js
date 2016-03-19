var last_val = "";
var conversion = null;
var hashChanged = false;

function myEncodeURI(s)
{
  var i;
  var out = "";
  for(i=0;i<s.length;i++)
  {
    if(s[i] <= '\xff')
      out += encodeURI(s[i]);
    else
      out += s[i]; // do not encode chinese characters 
  }
  return out;
}

function updatePinyin()
{
  var input = $('#input')
  if(input == null)
    return;
  var new_val = input.val();
  if(new_val == last_val)
    return;
  
  if(new_val == "")
  {
    $('#characters').text("");
    $('#pinyin').text("");
    $('#english').text("");
  }
  $.getJSON("/pinyin/convert/?c="+encodeURI(new_val), updatePinyinSuccess);
  last_val = new_val;
}

function updatePinyinSuccess(data)
{
  conversion = data;
  if(hashChanged)
  {
    showConversion();
    hashChanged = false;
  }
}

function formatZi(character)
{
  if (character == " ")
    return "&nbsp;";
  c = character.charCodeAt(0);
  if((c >= 0x2E80 && c <= 0xD7FF) || (c >= 0x20000 && c <= 0x2FA1D))
    return "<a href='/dict/zi/"+character+"'>"+character+"</a>";
  return character;
}

function v_simplified() { return $.cookie('variant') != "traditional"; }
function v_traditional() { return $.cookie('variant') == "traditional"; }

function r_zhuyin() { return $.cookie('romanization') == "zhuyin"; }
function r_pinyin() { return $.cookie('romanization') != "zhuyin" && $.cookie('romanization') != "pinyin_ascii"; }
function r_pinyin_ascii() { return $.cookie('romanization') == "pinyin_ascii"; }

function makeConversionTable(simplified, traditional, pinyin_s, english)
{
  var s = "<table><tr class='characters'>";
  var pinyin_pieces = pinyin_s.split(" ");
  var pinyin_texts = new Array()

  var characters = (v_simplified() ? simplified : traditional);
  for(var j=0;j<characters.length;j++)
  {
    var val = formatZi(characters.charAt(j))
    s += "<td>"+val+"</td>";
    if(r_zhuyin())
    {
      val = bopomofo[pinyin_pieces[j]];
      if(!val)
        val = "&nbsp;";
      else
      {
        val = val.zhuyin;
        var tone = pinyin_pieces[j][pinyin_pieces[j].length-1]
        var accent = bopomofo[tone].zhuyin
        s += "<td class='zhuyin'><div>"+val+
          "<span"+(tone==5 ? " class='dot'" : "")+">"+accent+"</span>"+
          "</div></td>";
        pinyin_texts.push(val+accent)
      } 
    }
  }
  s += "</tr><tr class='pinyin'>";

  if(!r_zhuyin())
  {
    for(var j=0;j<pinyin_pieces.length;j++)
    {
      var val = bopomofo[pinyin_pieces[j]];

      if(!val)
       	val = "&nbsp;";
      else
      {
        if(r_pinyin())
          val = val.pinyin;
        else
          val = pinyin_pieces[j];
        pinyin_texts.push(val)
      }
      
      s += "<td>"+val+"</td>";
    }
  }

  if(english != undefined)
  {
    s += "</tr><tr class='english'>";
    var colspan = simplified.length;
    var htmlclass = "w"+simplified.length;
    if(r_zhuyin())
    {
      colspan *= 2;
      htmlclass += " z";
    }
    s += "<td colspan="+colspan+"><p class='"+htmlclass+"'>"+english+"</p></td>";
  }
  s += "</tr></table>";

  pinyin_text = pinyin_texts.join(" ")
  return { "table": s, "pinyin_text": pinyin_text }
}

function showConversion()
{
  var data = conversion;
  ci = 0;
  var table_array = new Array();
  for(var i=0;i<data.e.length;i++)
  {
    var chars = data.c[i];
    if(data.s.charAt(ci) == '\n')
    {
      ci += 1;
      table_array.push("<br class='clear'/>\n");
      continue;
    }

    simplified = data.s.substring(ci,ci+chars);
    traditional = data.t.substring(ci,ci+chars);
    pinyin = ""
    for(var j=0;j<chars;j++)
    {
      if(pinyin != "")
        pinyin += " ";
      pinyin += data.p[ci+j]
    }
    ci += chars;

    // check for newline
    var span_class
    if(data.s.charAt(ci) == "\n" || ci == data.s.length)
      span_class = 'conversion end_of_line'
    else
      span_class = 'conversion'

    english = data.e[i];
    table_array.push("<span class='"+span_class+"'><span class='t'>"+
      traditional+"</span><span class='s'>"+simplified+"</span><span class='p'>"+
      pinyin+"</span><span class='e'>"+english+"</span></span>");
  }
  $('#conversion').html(table_array.join("")+"<br class='clear'/><textarea id='pinyin_text' readonly=1 rows=6 cols=60></textarea>");
  formatConversions();
}

function buttonClick()
{
  window.location = '#'+myEncodeURI($('#input').val());
}

function hashChange()
{
  $('#input').val(decodeURI(window.location.hash.substr(1)));
  if(conversion != null && conversion.q == $('#input').val())
  {
    showConversion();    
  }
  else
  {
    hashChanged = true;
  }
}

function formatConversion(index)
{
  var simplified = $(this).find(".s").html();
  var traditional = $(this).find(".t").html();
  var pinyin = $(this).find(".p").html();
  var english = $(this).find(".e").html();
  var conversion = makeConversionTable(simplified, traditional, pinyin, english);
  $(this).find("table").remove();
  $(this).append("<table>"+conversion.table+"</table>");

  var separator
  if($(this).is(".end_of_line"))
    separator = "\n"
  else
    separator = " "

  $("#pinyin_text").append(conversion.pinyin_text+separator)
}

function formatConversions()
{
  $("#pinyin_text").html("")
  $(".conversion").each(formatConversion);
}

function showVariantDivs()
{
  if(v_simplified())
  {
    $(".show_simplified").show();
    $(".show_traditional").hide();
  }
  else
  {
    $(".show_simplified").hide();
    $(".show_traditional").show();
  }
}

function settingsChange()
{
  $.cookie('romanization',$('#romanization').val(), {expires: 700, path: '/'});
  $.cookie('variant',$('#variant').val(), {expires: 700, path: '/'});
  formatConversions();
  showVariantDivs();
}

function setupSettings()
{
  $('#romanization').val(r_pinyin() ? "pinyin" : $.cookie('romanization'))
  $('#variant').val(v_simplified() ? "simplified" : "traditional")
  $('#romanization').change(settingsChange);
  $('#variant').change(settingsChange);
}

function dictionaryPinyinSubmit()
{
  pinyin = $("#dictionary_pinyin_input").val()
  current_syllable = ""
  new_val = ""
  for(i=0;i<pinyin.length;i++)
  {
    // decide whether to add a space before sticking the character in
    new_letter = pinyin[i]
    if(new_letter == " ")
    {
      // new syllable
      current_syllable = ""

      // add only one space
      if(new_val[new_val.length-1] != " ")
	new_val += " "
    }
    else if(new_letter >= "0" && new_letter <= "9")
    {
      // adding a new number
      current_syllable = ""
      new_val += new_letter+" "
    }
    else
    {
      // trying to add a new letter
      new_syllable = current_syllable+new_letter
      
      if(bopomofo[current_syllable+"1"] != undefined &&
	 bopomofo[new_syllable+"1"] == undefined &&
	 current_syllable != "")
      {
	// adding the character would stop a valid syllable
	// so add a space!
	new_val += " "
	current_syllable = new_letter
      }
      else
      {
	current_syllable += new_letter
      }
      new_val += new_letter
    }
  }
  $("#dictionary_pinyin_input").val(new_val)
  return true
}

function setup()
{
  if(window.location.hash != "#" && window.location.hash != "")
  {
    hashChange();
  }
  window.setInterval(updatePinyin, 100);  
  $(window).hashchange(hashChange);
  formatConversions();
  showVariantDivs();
  setupSettings();
  $("#dictionary_pinyin").submit(dictionaryPinyinSubmit)

  blogSetup()
}

$(document).ready(setup);
