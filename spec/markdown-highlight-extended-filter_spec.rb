require 'markdown-highlight-extended-filter'

RSpec.describe "MarkdownHighlightExtendedFilter" do
  let(:pipeline) {
    HTML::Pipeline.new [MarkdownHighlightExtendedFilter]
  }

  let(:rendered) {
    pipeline.call(text)[:output]
  }

  describe "no args" do
    let(:text) { <<-TEXT
```
def abc
  123
end
```
TEXT
    }

    it "renders correctly" do
      expect(rendered).to eq <<-HTML
<figure class='code'><pre lang="plain">def abc
  123
end</pre></figure>
HTML
    end
  end

  describe "lang arg only" do
    let(:text) { <<-TEXT
```ruby
def abc
  123
end
```
TEXT
    }

    it "renders correctly" do
      expect(rendered).to eq <<-HTML
<figure class='code'><figcaption><span></span></figcaption><div class="highlight highlight-ruby"><pre><span class="k">def</span> <span class="nf">abc</span>
  <span class="mi">123</span>
<span class="k">end</span>
</pre></div></figure>
HTML
    end
  end

  describe "lang and title args" do
    let(:text) { <<-TEXT
```ruby Hello World
def abc
  123
end
```
TEXT
    }

    it "renders correctly" do
      expect(rendered).to eq <<-HTML
<figure class='code'><figcaption><span>Hello World</span></figcaption><div class="highlight highlight-ruby"><pre><span class="k">def</span> <span class="nf">abc</span>
  <span class="mi">123</span>
<span class="k">end</span>
</pre></div></figure>
HTML
    end
  end

  describe "lang, title, url args" do
    let(:text) { <<-TEXT
```ruby Hello World http://www.example.com
def abc
  123
end
```
TEXT
    }

    it "renders correctly" do
      expect(rendered).to eq <<-HTML
<figure class='code'><figcaption><span>Hello World</span><a href='http://www.example.com'>link</a></figcaption><div class="highlight highlight-ruby"><pre><span class="k">def</span> <span class="nf">abc</span>
  <span class="mi">123</span>
<span class="k">end</span>
</pre></div></figure>
HTML
    end
  end

  describe "lang, title, url, link-title args" do
    let(:text) { <<-TEXT
```ruby Hello World http://www.example.com Example
def abc
  123
end
```
TEXT
    }

    it "renders correctly" do
      expect(rendered).to eq <<-HTML
<figure class='code'><figcaption><span>Hello World</span><a href='http://www.example.com'>Example</a></figcaption><div class="highlight highlight-ruby"><pre><span class="k">def</span> <span class="nf">abc</span>
  <span class="mi">123</span>
<span class="k">end</span>
</pre></div></figure>
HTML
    end
  end
end
