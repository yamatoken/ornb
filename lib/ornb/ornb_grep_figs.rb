module Ornb
  class CLI < Thor
    private
    def http_link(m)
      print 'http link:'.green
      p m
    end
    
    def file_link(m)
      print 'file link:'.green
      if File.exists?(m[1])
        puts m[1].green
      else
        puts m[1].red
        puts File.basename(m[1]).red
      end
    end
  end
end
