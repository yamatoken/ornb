module Ornb
  class CLI < Thor
    private
    def org_to_html(dirs)
      replace = "#{ENV['HOME']}/.emacs.d/theme-readtheorg.setup"
      Dir.glob(dirs).each do |file|
        if File.extname(file)=='.org'
          ["/Users/bob/org-html-themes/setup/theme-readtheorg.setup",
           "/Users/bob/Github/org-html-themes/setup/theme-readtheorg-local-daddygongon.setup",
           "/Users/bob/org-html-themes/setup/theme-readtheorg-local-daddygongon.setup",
           "/Users/bob/Github/lib/theme-readtheorg.setup"].each do |orig|
            File.write(file, File.read(file).gsub(orig,replace))
          end
          p command = "emacs #{file} --batch -f org-html-export-to-html --kill"
          system command
        end
      end
    end
  end
end
