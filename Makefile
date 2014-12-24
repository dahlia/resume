
PANDOC=pandoc

all: resume

resume: resume.txt index.html resume.odt

resume.txt: resume.rst
	cp resume.rst resume.txt

index.html: resume.rst style.css
	$(PANDOC) --base-header=2 -f rst -t html -s -S -c style.css \
	          -o index.html resume.rst

resume.odt: resume.rst
	$(PANDOC) -f rst -t odt -o resume.odt resume.txt

clean:
	rm resume.txt index.html resume.odt
