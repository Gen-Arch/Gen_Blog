# coding: utf-8
require "./helper/application_helper.rb"

class Myapp
    include ApplicationHelper
    def initialize
        @md_page = "Arch_install"
        @txt = File.open("#{File.dirname(__FILE__)}/md/#{@md_page}.md", "rb").read
    end

    def puts_md
        @txt.force_encoding("utf-8")
        puts @txt
        md = markdown(@txt)
        puts md
    end
end

app = Myapp.new
app.puts_md