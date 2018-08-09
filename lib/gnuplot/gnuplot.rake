desc "gnuplot data"
task :gnuplot do
  # data_all = make_data
  data_all = [{data: [[0,1,2],[0,1,4]], title:'hoge'}]
  plot(data_all)
end

require 'gnuplot'
def plot(data_all)
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
          ds.title=result[:title]
        end
#        plot.data << add_function
      end
    end
  end
end

def add_function
  f0 = "x**2"
  Gnuplot::DataSet.new(f0){|ds|
    ds.with="line linecolor \"red\""
  }
end
