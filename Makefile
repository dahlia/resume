
PANDOC=pandoc

all: index

index: index.txt index.html index.odt

index.txt: index.markdown
	cp index.markdown index.txt

index.html: index.markdown footer.html
	$(PANDOC) -f markdown -t html -s -S -A footer.html -T Resume -o index.html \
			  index.txt

index.odt: index.markdown
	$(PANDOC) -f markdown -t odt -o index.odt index.txt

clean:
	rm index.txt index.html index.odt
