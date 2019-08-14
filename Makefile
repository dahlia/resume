
PANDOC=pandoc

all: resume

resume: resume.txt index.html resume.pdf

resume.txt: resume.rst
	cp resume.rst resume.txt

index.html: resume.rst style.css
	$(PANDOC) --base-header=2 -f rst+smart -t html -s -c style.css \
	          -o index.html resume.rst

resume.pdf: resume.rst
	$(PANDOC) -f rst+smart -o resume.pdf --pdf-engine=weasyprint resume.rst

clean:
	rm resume.txt index.html resume.pdf
