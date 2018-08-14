require 'colorize'

task :default do
  system 'rake -f gnuplot.rake -T'
end

desc 'puts newest gnuplot.rake to vasprun'
task :puts_newest do
  file = 'gnuplot.rake'
  p source = File.join(Dir.pwd, file)
  p target = File.join('/Users/bob/Github/ornb/lib/gnuplot',file)
  system("cp -i #{source} #{target}")
end

desc "gnuplot all data" # sample for multiple gnuplot
task :all do
  data_set = [["./Res_0_3330_108_fix","-3.74278 +0.00024*x +0.00336*x**2 -0.00011*x**3 +0.00005*x**4"],
   ["./Res_0_2220_32_fix","-3.74313 +0.00032*x +0.00363*x**2 -0.00009*x**3 -0.00000*x**4"],
   ["./Res_0_4440_256_fix","-3.74158 +0.00050*x +0.00337*x**2 -0.00016*x**3 +0.00002*x**4"],
   ["./Res_0_1110_4_fix","-3.74350 -0.00263*x +0.00635*x**2 +0.00056*x**3 -0.00068*x**4"]]
  data_set.each do |file, f0|
    plot(gets_data(file), file, f0)
  end
  exit
end

desc "gets f0 from data" # sample for multiple plot in specific files
task :all_f0 do
  Dir.glob("./Res_0_*_fix").each do |file|
    p file
    system "find_cubic_min #{file}"
  end
  exit
end

desc "gnuplot data"
task :gnuplot do
  # data_all = make_data
  print "\n\n Rev gets_data, add_functions for real data. \n\n".blue
  if file = ARGV[3]
    data_all = gets_data(file)
  else
    data_all = [{data: [[0,1,2],[0,1,4]], title:'hoge'}]
  end
  plot(data_all)
end

require 'gnuplot'
def plot(data_all, title = nil, f0 = "x**2")
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
#      plot.terminal "aqua font 'Helvetica,20'"
#      plot.xlabel "x-value"
#      plot.ylabel "y-value"
#      plot.set "xtics (#{set_xtics(9)})"
#      plot.set "xrange [0:(2022.5-2014)*12]"
#      plot.set "yrange [0:5*10**3]"
#      plot.set "mytics 10"
      data_all.each do |result|
        plot.data << Gnuplot::DataSet.new(result[:data]) do |ds|
          ds.with="lp"
          ds.title=title
        end
        plot.data << add_function(f0)
      end
    end
  end
end

# transpose the sorted data
def transpose(data)
  data_t = [[],[]]
  data.sort!.each do |data|
    data_t[0] << data[0]
    data_t[1] << data[1]
  end
  data_t
end

def gets_data(file)
  n = file.split('_')[3].to_f # gets num from file_name
  data = []
  File.readlines(file)[1..-1].each do |line|
    p vals = line.split(/\s+/)
    data << [vals[0].to_f, vals[5].to_f/n] # select plot data
  end
  [{data: transpose(data), title:'hoge'}]
end

def add_function(f0 = "x**2")
  Gnuplot::DataSet.new(f0){|ds|
    ds.with="line linecolor \"red\""
  }
end
