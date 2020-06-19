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

  \title{}
  \author{情報科学科 \hspace{5mm} 12345678 \hspace{5mm} your name}
  \date{}

  \maketitle
EOS
  head2 = <<'EOS'
  {\small\setlength\baselineskip{15pt}	% 参考文献は小さめの文字で行間を詰めてある
  \begin{thebibliography}{9}
  \bibitem{} 
  \end{thebibliography}
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
