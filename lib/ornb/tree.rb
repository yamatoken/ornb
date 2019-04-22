module Ornb
  class CLI < Thor
    private
    def sort_num(list)
      split_list = []
      list.each do |file|
        split_list << [file.split('_')[0],file]
      end
      split_list.sort! do |a,b|
        File.basename(a[0]).to_i <=> File.basename(b[0]).to_i
      end
      return split_list.inject([]){|result, list| result << list[1]}
    end

    def mk_tree(dir, level)
      dir = './'+dir unless dir[0..1]=='./'
      @tree <<  "*"*level + " [["+dir+"]]"
      level += 1
      dirs = []
      sort_num(Dir.glob(File.join(dir,'*')).sort).each do |file|
        b_file = File.basename(file)
        unless File.directory?(file)
          @tree <<  "-"*level + " [["+File.join(dir,b_file)+"]["+File.basename(b_file)+"]]"
        else
          dirs << file # dirs should be late.
        end
      end
      dirs.each do |file|
        b_file = File.basename(file)
        mk_tree(File.join(dir,b_file), level)
      end
    end

    def head_check(line, max_level)
      m = line.match(/^([-|*]+)(.+)\]\]/)
      line_level = m[1].size
      if line_level < max_level
        return m[1][0] == '*' ? m[1]+m[2]+"/]]\n" : "-"+m[2]+"]]\n"
      elsif line_level == max_level
        return m[1][0] == '*' ? "-"+m[2]+"/]]\n" :  "-"+m[2]+"]]\n"
      else
        return nil
      end
    end
  end
end
