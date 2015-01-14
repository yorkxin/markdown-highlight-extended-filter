# Markdown Highlight Extended Filter for HTML::Pipeline

An HTML::Pipeline filter to convert Octopress-flavored syntax highlighting, like this:

    ``` [language] [title] [url] [link text]
    code snippet
    ```

See: http://octopress.org/docs/blogging/code/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'markdown-highlight-extended-filter'
```

And then execute:

    $ bundle

Or install it without Gemfile (like, Jekyll project):

    $ gem install markdown-highlight-extended-filter

## Usage

```ruby
pipeline = HTML::Pipeline.new [
  MarkdownHighlightExtendedFilter,
  HTML::Pipeline::MarkdownFilter
]

pipeline.call(File.read("example.md"))[:output]
```

example.md:

    Here is a sample:

    ```ruby test.rb
    def abc
      123
    end
    ```

### Jekyll site usage

This filter is for HTML::Pipeline, so you must use HTML::Pipeline to
generate your content from Markdown. See [gjtorikian/jekyll-html-pipeline](https://github.com/gjtorikian/jekyll-html-pipeline) for more details.

Edit `_config.yml` and configure the pieline like this:

```yml
gems:
- jekyll-html-pipeline
- markdown-highlight-extended-filter

markdown: HTMLPipeline

html_pipeline:
  filters:
    - "MarkdownHighlightExtendedFilter" # Must put before markdownfilter
    - "markdownfilter"
```

## Known Issues

Unsupported features:

* Line Numbers
* Line Highlights

These were defined in [Octopress's document](http://octopress.org/docs/blogging/code/) as additional options. (PR welcome!)

## Special Thanks

The code to convert complex syntax highlighting was stolen from [Octopress Project](https://github.com/imathis/octopress/).
See [imathis/octopress:plugins/backtick_code_block.rb@73e5404](https://github.com/imathis/octopress/blob/73e540409ceb8bc18048b6a96a4b815fc303ea28/plugins/backtick_code_block.rb) for the original source code. Also thanks contributers: @imathis, @fhemberger and @liangsun. I hope you don't mind :D

## Contributing

1. Fork it ( https://github.com/chitsaou/markdown-highlight-extended-filter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
