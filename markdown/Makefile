all:    resume.html resume.pdf resume.tex

%.html: %.md
	pandoc -t html -o $@ $< -c resume.css

%.pdf:  %.md
	pandoc -o $@ $<

%.tex:  %.md
	pandoc -o $@ $<

clean:
	rm -f *~ *.html *.log *.pdf *.tex
