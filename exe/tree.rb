
def print_dir(file,level,cont)
  level += 1
  return "- [[#{file}]]\n" if level > $deep_level
  print "*"*level+" #{file}\n"
  dir = File.join(file,"*")
  Dir.glob(dir).each do |file|
    case File.ftype(file)
    when 'link', 'file'
      cont << "- [[#{file}]]\n"
    when 'directory'
      print print_dir(file,level,'')
    end
  end
  cont
end

system 'rm -f *~ *# #*'
$deep_level = 2
cont =  print_dir('.', 0, '')
print "\n\n"+cont+"\n"
