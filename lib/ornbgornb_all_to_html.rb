def org_all_to_html(*argv)
dirs = argv[0] || '**/*'
Dir.glob(dirs).each do |file|
  if File.extname(file)=='.org'
    p command = "emacs #{file} --batch -f org-html-export-to-html --kill"
    system command
  end
end
