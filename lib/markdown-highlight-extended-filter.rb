require "html/pipeline"
require "rouge"

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
    if lexer = lexer_for(lang, code)
      # XXX: Rouge wrapper `<pre css_class><code>` is different from
      # what pygments generates `<div css_class><pre>`.
      # To keep compatibility, we don't use Rouge's warp, and wrap it manually.
      html = Rouge::Formatters::HTML.format(lexer.lex(code), :wrap => false)
      %Q{<div class="highlight highlight-#{lexer.tag}"><pre>#{html}\n</pre></div>}
    else
      "<pre>#{code}</pre>"
    end
  end

  def lexer_for(lang, code)
    Rouge::Lexer.find(lang)
  end
end
