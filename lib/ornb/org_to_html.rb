def org_to_html(dirs)
  Dir.glob(dirs).each do |file|
    if File.extname(file)=='.org'
      ["/Users/bob/org-html-themes/setup/theme-readtheorg.setup",
       "/Users/bob/Github/org-html-themes/setup/theme-readtheorg-local-daddygongon.setup",
       "/Users/bob/org-html-themes/setup/theme-readtheorg-local-daddygongon.setup"].each do |orig|
        replace = "/Users/bob/Github/ornb/lib/theme-readtheorg.setup"
        File.write(file, File.read(file).gsub(orig,replace))
      end
      p command = "emacs #{file} --batch -f org-html-export-to-html --kill"
      system command
    end
  end
end
