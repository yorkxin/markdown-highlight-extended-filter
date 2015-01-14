require "html/pipeline"
require "pygments.rb"
require "linguist"

# Stolen from https://github.com/imathis/octopress/blob/master/plugins/backtick_code_block.rb
# (MIT License)
class MarkdownHighlightExtendedFilter < HTML::Pipeline::TextFilter
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i

  def call
    format_syntax(@text)
  end

  def format_syntax(text)
    text.gsub(/^`{3} *([^\n]+)?\n(.+?)\n`{3}/m) do
      options = $1 || ''
      str = $2

      if options =~ AllOptions
        lang = $1
        caption = "<figcaption><span>#{$2}</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
      elsif options =~ LangCaption
        lang = $1
        caption = "<figcaption><span>#{$2}</span></figcaption>"
      end

      if str.match(/\A( {4}|\t)/)
        str = str.gsub(/^( {4}|\t)/, '')
      end
      if lang.nil? || lang == 'plain'
        code = highlight_code(str.gsub('<','&lt;').gsub('>','&gt;'), "plain")
        "<figure class='code'>#{caption}#{code}</figure>"
      else
        if lang.include? "-raw"
          raw = "``` #{options.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = highlight_code(str, lang)
          "<figure class='code'>#{caption}#{code}</figure>"
        end
      end
    end
  end

  def highlight_code(code, lang)
    if lexer = lexer_for(lang)
      lexer.highlight(code, :options => { :cssclass => "highlight highlight-#{lang}" })
    else
      "<pre>#{code}</pre>"
    end
  end

  # https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/syntax_highlight_filter.rb#L38
  def lexer_for(lang)
    (Linguist::Language[lang] && Linguist::Language[lang].lexer) || Pygments::Lexer[lang]
  end
end
