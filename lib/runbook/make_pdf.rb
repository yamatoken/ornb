require "./runbook/convert"
require "colorize"

Runbook.book "Make PDF" do
  description <<-DESC
    This is a make PDF from org
  DESC

  section "Make latex" do
    $t_file = "report"
    step "Load org file" do
      note "Load org file"
      ruby_command do
        str = Dir.glob("*.org")
        #p str
        str.each do |name|
          puts "your org file is " + name.red + " ? (y or n)"
          res = $stdin.gets.chomp

          if res == "y"
            $file = name.match(/(.*).org/)[1]
            break
          elsif res == "n"
            if name == str[str.size - 1]
              puts "This directory not have the objective file".red
              exit
            end
          end
        end
        #$file = Dir.glob("*.org")[0].match(/(.*).org/)[1]
      end
    end
    step "Make tex file" do
      note "Make tex file"
      #p $file
      ruby_command do
        system "emacs #{$file}.org --batch -f org-latex-export-to-latex --kill"
      end
    end
    step "Load and Convert tex file" do
      ruby_command do
        $lines = File.readlines("#{$file}.tex")
        $lines = convert_thesis($lines)
      end
    end
    step "Make new tex file for pdf" do
      note "Make new tex file for pdf"
      ruby_command do
        File.open("#{$t_file}.tex", "w") do |f|
          $lines.each { |line| f.print line }
        end
      end
    end
  end

  section "Make PDF" do
    step "Make pdf" do
      note "Make pdf"
      ruby_command do
        commands = ["platex #{$t_file}.tex",
                    "bibtex #{$t_file}.tex",
                    "platex #{$t_file}.tex",
                    "dvipdfmx #{$t_file}.dvi"]
        commands.each { |com| system com }
      end
    end
    step "Move report" do
      note "Move report"
      ruby_command do
        commands = ["mkdir report",
                    "mv -f #{$t_file}.* ./report",
                    "open ./report/#{$t_file}.pdf"]
        commands.each { |com| system com }
      end
    end
  end
end
