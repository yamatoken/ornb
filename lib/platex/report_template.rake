file = ARGV[3] || Dir.glob("*.org")[0].match(/(.*).org/)[1]
t_file = "report"

desc "make report template of tex"
task :template do
  command = "emacs #{file}.org --batch -f org-latex-export-to-latex --kill"
  system command
  lines = File.readlines("#{file}.tex")
  lines = convert_template(lines)
  File.open("#{t_file}.tex", "w") do |f|
    lines.each { |line| f.print line }
  end
end

desc "make pdf"
task :platex do
  commands = ["platex #{t_file}.tex",
              "bibtex #{t_file}.tex",
              "platex #{t_file}.tex",
              "dvipdfmx #{t_file}.dvi",
              "open #{t_file}.pdf"]
  commands.each { |com| system com }
end

def convert_template(lines)
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

  \title{}
  \author{情報科学科 \hspace{5mm} 12345678 \hspace{5mm} your name}
  \date{}

  \maketitle
EOS
  head2 = <<'EOS'
  {\small\setlength\baselineskip{10pt}	% 参考文献は小さめの文字で行間を詰めてある
  \begin{thebibliography}{9}
  # 消してください(この行を含めて3行) 参考文献の書き方の例: 
  # webサイトなら /bibitem{} サイトタイトル - サイト名, URL(accsessd on day month year)
  # 文献等なら /bibitem{} 著者名 - タイトル(出版社, 出版年)
  }
  \end{document}
EOS
  new_line = [head]
  lines[31..-1].each do |line|
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
