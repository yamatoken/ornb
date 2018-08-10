file = ARGV[0] || 'README.org'

File.readlines(file).each_with_index do |line, i|
  line.scan(/\[\[(.+?)\]\]/) do |match|
    link = (m = match[0].match(/(.+)\]\[/) )? m[1] : match[0].to_s
    unless File.exists?(link)
      next if link.match(/^\#/)
      printf("%4d:%s:",i,link)
      printf("%s\n",line.chomp)
      search_file(link)
    end
  end
end
