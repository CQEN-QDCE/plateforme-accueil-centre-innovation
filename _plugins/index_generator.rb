module IndexGenerator
  class Generator < Jekyll::Generator
    def generate(site)
      site.pages.each do |page|
        # Il faut ignorer le README.md du repertoire racine.
        if page.name == 'README.md' && page.dir != '/'
          site.pages << IndexCopyPage.new(site, page)
        end
      end
    end
  end

  class IndexCopyPage < Jekyll::Page
    def initialize(site, page)
      @site = site
      @base = site.source
      @dir = page.dir
      @name = 'index.md'
      @content = page.content
      @data = {
        'title' => page.data['title'],
        'layout' => page.data['layout'],
        'index' => true
      }
      #self.read_yaml(File.join(site.source, '_layouts'), page.data['layout'])
      self.process(@name)
    end
  end
end