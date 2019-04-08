module Ornb
  class CLI < Thor
    def mv(command, source, target, file_name)
      p name = File.basename(target,'.*')
      real_run = (command == 'mv_real') ? true : false

      if source.include?('*')
        Dir.glob(source).each do |file|
          p extname = File.extname(file)
          FileUtils::DryRun.mv(file, name+extname, verbose: true)
        end
      end
      p i_file = file_name #'README.org'|| ARGV[3]
      p o_file = 'tmp.org'


      File.write o_file, File.read(i_file).gsub!(source, target)

      if real_run
        FileUtils.mv(source, target, verbose: true)
        p system "mv #{o_file} #{i_file}"
      else
        FileUtils::DryRun.mv(source, target, verbose: true)
      end
    end
  end
end
