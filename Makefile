AUTHORS = $(shell head -1 LICENSE |cut -d\  -f3-)

SRC = $(notdir $(wildcard src/*))
OBJ = build/obj/iaria-lite.ins build/obj/iaria-lite.dtx
DOC_PDF = build/doc/iaria-lite.pdf
LICENSE = build/dist/iaria-lite/COPYING
ARCHIVE = dist/iaria-lite.zip
LICENSE_TEXT = $(shell cat LICENSE)

VPATH = src

#LATEXMK = latexmk -latexoption=-interaction=nonstopmode -latexoption=-halt-on-error -pdf
LATEXMK = texliveonfly --compiler=latexmk --arguments='-shell-escape -pdf'

MAKEDTX = build/tools/makedtx/makedtx.pl
MAKEDTX_ARCHIVE = makedtx-1_2.zip

default: compile

compile: $(OBJ) $(DOC_PDF)

dist : $(ARCHIVE)

$(ARCHIVE) : $(OBJ) $(DOC_PDF) $(LICENSE)
	mkdir -p build/dist/iaria-lite
	cp -r static/* build/dist/iaria-lite
	cd build/dist/iaria-lite; unzip -o *.zip -d "template"
	rm build/dist/iaria-lite/*.zip
	cp $(OBJ) $(DOC_PDF) build/dist/iaria-lite
	chmod -R -x+X build/dist
	echo "== check files: falsely marked as executable? =="
	ls -l build/dist/iaria-lite/*
	echo "== /check files =="
	mkdir -p dist
	cd build/dist; zip -r ../../$@ *

# Extract makedtx.pl
$(MAKEDTX) : dependencies/$(MAKEDTX_ARCHIVE)
	mkdir -p build/tools
	cd build/tools; unzip -o ../../$<
	cd build/tools/makedtx; latex makedtx.ins

# build dtx and ins files
$(OBJ) : $(SRC) $(MAKEDTX)
	mkdir -p build/obj
	perl $(MAKEDTX) \
		-macrocode ".*" \
		-src "($(subst $() $(),|,$(SRC)))=>\1" \
		-dir "src" \
		-author "$(AUTHORS)" \
		-date "2024-$(shell date +%Y)" \
		-setambles ".*=>\nopreamble" \
		-doc "doc/iaria-lite.tex" \
		-preamble "$(LICENSE_TEXT)" \
		iaria-lite
	sed -e "$$(($$(wc -l < iaria-lite.ins)-1))r patch/msg.txt" iaria-lite.ins
	mv $(notdir $(OBJ)) build/obj

# Build Documentation PDF from iaria-lite.dtx
$(DOC_PDF) : build/obj/iaria-lite.dtx
	mkdir -p build/doc
	cp $< build/doc
	cd build/doc; $(LATEXMK) iaria-lite.dtx

$(LICENSE) : LICENSE
	mkdir -p build/dist/iaria-lite
	cp $^ $@

clean:
	rm -rf build
	rm -rf dist

.PHONY: default compile dist clean