
PANDOC:=$(shell which pandoc)
SEONBI:=$(shell which seonbi)

languages = en ko

all: public

public: $(foreach lang,$(languages),public/$(lang)/index.html) $(foreach lang,$(languages),public/$(lang)/resume.pdf) public/index.html

public/index.html: public/en/index.html public/redir.js
	sed 's/<head>/<head><base href="en\/"\/><script src="..\/redir.js"><\/script>/' \
	  public/en/index.html > public/index.html

public/redir.js: redir.js
	cp redir.js public/redir.js

$(foreach lang,$(languages),public/$(lang)/resume.txt): public/%/resume.txt: %.rst
	mkdir -p "`dirname $@`"
	cp $< $@

public/ko/resume.txt: ko.rst
	mkdir -p public/ko/
	$(SEONBI) -o public/ko/resume.txt -e utf-8 -A -D -r hangul-only -R "洪民憙:홍민희 (洪民憙)" ko.rst

public/style.css: style.css
	mkdir -p public/
	cp style.css public/style.css

$(foreach lang,$(languages),public/$(lang)/index.html): public/%/index.html: public/%/resume.txt public/style.css
	$(PANDOC) \
		--base-header=2 \
		-f rst+smart \
		-t html \
		-s \
		-c ../style.css \
		-M lang=$(shell basename $(shell dirname "$<")) \
		-o $@ $<
	$(foreach lang,$(languages),[[ $(shell basename $(shell dirname "$<")) = "$(lang)" ]] || sed -i 's|</head>|<link rel="alternate" hreflang="$(lang)" href="../$(lang)/"/></head>|' $@;)
	sed -i \
		's|</head>|<link rel="alternate" href="resume.pdf" hreftype="application/pdf" hreflang="$(shell basename $(shell dirname "$<"))"/></head>|' \
		$@

$(foreach lang,$(languages),public/$(lang)/resume.pdf): public/%/resume.pdf: public/%/resume.txt public/style.css
	$(PANDOC) \
		--base-header=2 \
		-f rst+smart \
		--pdf-engine=weasyprint \
		--pdf-engine-opt="-sstyle.css" \
		--dpi=192 \
		-o $@ $<

clean:
	rm -rf public
