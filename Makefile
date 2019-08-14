
PANDOC=pandoc

all: public

public: public/resume.txt public/index.html public/resume.pdf

public/resume.txt: resume.rst
	mkdir -p public
	cp resume.rst public/resume.txt

public/style.css: style.css
	cp style.css public/style.css

public/index.html: public/resume.txt public/style.css
	$(PANDOC) --base-header=2 -f rst+smart -t html -s -c style.css \
	          -o public/index.html public/resume.txt

public/resume.pdf: public/resume.txt
	$(PANDOC) -f rst+smart --pdf-engine=weasyprint -o public/resume.pdf \
			  public/resume.txt

clean:
	rm -rf public
