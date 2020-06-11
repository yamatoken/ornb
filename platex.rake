# -*- coding: utf-8 -*-
file = Dir.glob("*.org")[0].match(/(.*).org/)[1]

desc "platex"
task :platex do
  lines = File.readlines("#{file}.tex")
  t_file = "thesis_midterm"
  lines = convert_thesis(lines)
  File.open("#{t_file}.tex", "w") do |f|
    lines.each { |line| f.print line }
  end
  #system "platex #{file}"
  commands = ["platex #{t_file}.tex",
              "bibtex #{t_file}.tex",
              "platex #{t_file}.tex",
              "dvipdfmx #{t_file}.dvi",
              "open #{t_file}.pdf"]
  commands.each { |com| system com }
end

def convert_thesis(lines)
  head = <<'EOS'
  \documentclass[a4j,twocolumn]{jsarticle}
  \usepackage[dvipdfmx]{graphicx}
  \usepackage{url}

  \setlength{\textheight}{275mm}
  \headheight 5mm
  \topmargin -30mm
  \textwidth 185mm
  \oddsidemargin -15mm
  \evensidemargin -15mm
  \pagestyle{empty}


  \begin{document} 

  \title{核崩壊と核分裂の違いについて}
  \author{情報科学科 \hspace{5mm} 27017561 \hspace{5mm} 山本 健太}
  \date{}

  \maketitle
EOS
  head2 = <<'EOS'
  {\small\setlength\baselineskip{15pt}	% 参考文献は小さめの文字で行間を詰めてある
  \begin{thebibliography}{9}
  \bibitem{houkai} 「放射性崩壊 wikipedia」,(https://ja.wikipedia.org/wiki/放射性崩壊).
  \bibitem{bunretu} 「核分裂反応 wikipedia」,(https://ja.wikipedia.org/wiki/核分裂反応).
  \bibitem{gakusei} 「原子核崩壊のメカニズムとは？理系学生のライターが詳しく解説！」，(https://study-z.net/100061260)．
  \end{thebibliography}
  }
  \end{document}
EOS
  new_line = [head]
  lines[32..-1].each do |line|
    #    if line.match(/\\tableofcontents\n/)
    #      line = "\\tableofcontents\n\\listoftables\n\\listoffigures\n\\pagebreak\n"
    #      p line
    #    end
    new_line << line
  end

  new_line.each do |line|
    line.gsub!('\end{document}', head2)
    # line.gsub!('\tableofcontents','\begin{document}')
    line.gsub!('\tableofcontents', "")
  end
  return new_line
end

desc "test"
task :test do
  #str = Dir.glob("*.org")[0].match(/(.*).org/)[1]
  str = Dir.glob("*.org")
  p str
end
