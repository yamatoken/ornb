require 'colorize'
require 'thor'
require 'fileutils'
require 'open3'

module Ornb
  class CLI < Thor
    def initialize(*argv)
      super(*argv)
      @lib = File.expand_path("../../../lib", __FILE__)
      puts 'ornb: org and ruby based note book by Shigeto R. Nishitani in 2019'
    end

    desc 'readme', 'make initial README.org'
    def readme(*argv)
      setup = "#{ENV['HOME']}/.emacs.d/org-mode/theme-readtheorg.setup"
      s_file = File.join(@lib, 'readme', 'README.org')
      p Dir.entries('.')
      if File.exists?('./README.org')
        puts setup.green
        puts "README.org exists. ".red
      else
        FileUtils.cp(s_file, '.', verbose: true)
      end
      if File.exists?(setup)
        puts "theme-readtheorg.setup exists. "
      else
        FileUtils.cp(File.join(@lib,File.basename(setup)), setup,
                     verbose: true)
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

    desc 'mv', 'move file'
    def mv(*argv)
      puts "When you mv directory, all the links in README.org should be adjusted ..."
      puts "DRYRUN Usage: ruby ornb.rb mv SOURCE TARGET [README.org]"
      puts "REALRUN Usage: ruby ornb.rb mv_real SOURCE TARGET [README.org]"

      command = argv[0] || 'mv_real'
      source = argv[1]
      target = argv[2]
      #if argv[3] == nil
      #  argv[3] == 'README.org'
      #end
      file_name = argv[3] || 'README.org'
      p file_name
      mv(command, source, target, file_name)
    end

    desc 'ornb_grep_figs', 'grep figs'
    def ornb_grep_figs(*argv)
      file = argv[0] || 'README.org'

      m = []
      File.readlines(file).each do |line|
        http_link(m) if m = line.match(/\[\[(.+)\]\[(.+)\]\]/)
        file_link(m) if m = line.match(/\[\[file:(.+)\]\]/)
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

    desc 'org_all_to_html', 'convert all ornb of [DIRS] to html'
    def org_all_to_html(*argv)
      dirs = argv[0] || '**/*'
      org_to_html(dirs)
    end

    desc 'say_hello', 'say hello'
    def say_hello(*argv)
      name = argv[0] || 'body'
      puts "Hello #{name}."
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
