#
# Makefile for creating HTML out of Markdown for euca2ool's documentation.  
#
# Pandoc is used for the conversion. 
#
# Pandoc sample installation on OSX (using Homebrew):
#
#   $> brew install haskell-platform
#   $> cabal install pandoc
#   $> export PATH=$HOME/.cabal/bin:$PATH
#

PANDOC_OPTS := -s -S --toc --chapters --number-sections -f markdown -H css/github.css
PANDOC_OPTS_INDEX := -s -S -f markdown -H css/github.css

INPUT_MDS := \
	user_guide_VMs.md \
	user_guide_elastic_IP.md \
	admin_guide.md


INDEX_MD := index.md
INDEX_HTML := index.html

OUTPUT_HTML = $(INPUT_MDS:.md=.html)

.PHONY: all html clean

all: html

html: idx $(OUTPUT_HTML)

idx:
	@echo Generating HTML index...
	@(echo "Main Menu" > $(INDEX_MD) ; \
	  echo "=========" >> $(INDEX_MD) ; \
	  echo "" >> $(INDEX_MD) ; \
	  for Md in $(INPUT_MDS) ; do \
	    echo "1. [$$(head -n1 $$Md)]($${Md%.*}.html)" ; \
	  done >> $(INDEX_MD) )
	@pandoc $(PANDOC_OPTS_INDEX) $(INDEX_MD) -o $(INDEX_HTML)

%.html: %.md
	@echo Generating HTML: $@
	@(OFFSET=$$(for F in $(INPUT_MDS) ; do echo $$F ; done | grep -n $< | cut -d: -f1) ; \
	  let OFFSET-- ; \
	  pandoc $(PANDOC_OPTS) --number-offset $$OFFSET $< -o $@)

clean:
	@echo Cleaning up
	@rm -f $(OUTPUT_HTML) $(INDEX_MD) $(INDEX_HTML)