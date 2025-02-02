# Prerequires (Debian):
# - fonts-noto-cjk
# - pandoc
# - texlive-xetex
# - <https://github.com/dahlia/seonbi>

# Prerequisites (macOS):
# - basictex
# - homebrew/cask-fonts/font-noto-serif-cjk-kr
# - gnu-sed
# - pandoc
# - <https://github.com/dahlia/seonbi>
SHELL:=$(shell which bash)
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
		--shift-heading-level-by=1 \
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

$(foreach lang,$(languages),public/$(lang)/resume.pdf): public/%/resume.pdf: public/%/resume.txt
	$(PANDOC) \
		--shift-heading-level-by=1 \
		-f rst+smart \
		--pdf-engine=xelatex \
		--variable=mainfont:"Noto Serif CJK KR" \
		--dpi=192 \
		-o $@ $<

clean:
	rm -rf public
