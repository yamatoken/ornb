require 'colorize'
require 'thor'
require 'fileutils'
require 'open3'

module Ornb
  class CLI < Thor
    def initialize(*argv)
      super(*argv)
      @lib = File.expand_path("../../../lib", __FILE__)
    end

    desc 'readme', 'make initial README.org'
    def readme(*argv)
      setup = File.join(@lib,"theme-readtheorg.setup")
      s_file = File.join(@lib, 'readme', 'README.org')
      p Dir.entries('.')
      if File.exists?('./README.org')
        puts "README.org exists. "
      else
        File.write('README.org',
                   File.read(s_file).gsub('THEME_SETUP_FILE',setup))
      end
    end

    desc 'plot', 'cp gnuplot.rake'
    def plot(*argv)
      target = 'gnuplot.rake'
      p s_file = File.join(@lib, File.basename(target,'.rake'), target)
      p Dir.entries('.')
      if File.exists?(target)
        puts target + " exists. "
      else
        FileUtils.cp(s_file, '.')
      end
    end

    desc 'platex', 'cp platex.rake'
    def platex(*argv)
      target = 'platex.rake'
      p s_file = File.join(@lib, File.basename(target,'.rake'), target)
      p Dir.entries('.')
      if File.exists?(target)
        puts target + " exists. "
      else
        FileUtils.cp(s_file, '.')
      end
    end

    desc 'tree', "tree [LEVEL=2] [DIR=\'.\']"
    def tree(*argv)
      max_level = argv[0] || 2
      dir = argv[1] || '.'

      @tree = []
      mk_tree(dir,1)
      @tree.each do |line|
        print head_check(line, max_level.to_i)
      end
    end

    desc 'link_check', 'link check'
    def link_check(*argv)
      file = argv[0] || 'README.org'
      puts "target_file: "+file
      File.readlines(file).each_with_index do |line, i|
        line.scan(/\[\[(.+?)\]\]/) do |match|
          link = (m = match[0].match(/(.+)\]\[/) )? m[1] : match[0].to_s
          find_file(link, i, line)
        end
      end
    end

    private
    def find_file(link, i_num, line)
      unless File.exists?(link)
        return if link.match(/^\#/)
        print "line #{i_num}:#{link}:".red
        printf("%s\n",line.chomp)
        p file = File.basename(link)
        command =  "find . -name #{file}"
        out, _err, _status = Open3.capture3 command
        puts out.blue
      end
    end
  end
end
