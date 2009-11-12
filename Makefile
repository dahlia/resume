
PANDOC=pandoc

all: index

index: index.txt index.html index.rtf

index.txt:
	cp index.markdown index.txt

index.html: footer.html
	$(PANDOC) -f markdown -t html -s -S -A footer.html -o index.html index.txt

index.rtf:
	$(PANDOC) -f markdown -t rtf -o index.rtf index.txt

