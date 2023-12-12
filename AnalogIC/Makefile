PROJECT:=AnalogIC

BUILD_DIR:=build

OUTPUT:=${BUILD_DIR}/${PROJECT}.pdf

FLAGS:=-xelatex -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}

STYS:=$(wildcard *.sty)
CLSS:=$(wildcard *.cls)
TEXS:=$(filter-out .fig.tex,$(wildcard *.tex))
FIGS:=$(wildcard *.fig.tex)
OCTS:=$(wildcard *.fig.m)
WLSS:=$(wildcard *.fig.wls)
ASCS:=$(wildcard *.fig.py)

FIGS_PDF:=$(addprefix ${BUILD_DIR}/,$(FIGS:.tex=.pdf))
OCTS_PDF:=$(addprefix ${BUILD_DIR}/,$(OCTS:.m=.pdf))
WLSS_PDF:=$(addprefix ${BUILD_DIR}/,$(WLSS:.wls=.pdf))
ASCS_PDF:=$(addprefix ${BUILD_DIR}/,$(ASCS:.py=.pdf))

default: ${BUILD_DIR} ${OUTPUT}
	@echo Makefile: Done!

${OUTPUT}: ${TEXS} ${FIGS_PDF} ${OCTS_PDF} ${WLSS_PDF} ${ASCS_PDF} ${STYS} ${CLSS}
	latexmk ${FLAGS} ${PROJECT}.tex
	touch $@

${BUILD_DIR}/%.fig.pdf:%.fig.tex ${STYS} ${CLSS}
	latexmk ${FLAGS} $<
	touch $@

${BUILD_DIR}/%.fig.pdf:%.fig.m
	octave-cli $<

${BUILD_DIR}/%.fig.pdf:%.fig.wls
	wolframscript.exe -script $<

${BUILD_DIR}/%.fig.pdf:%.fig.py
	/c/Anaconda3/python.exe $<

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

run:default
	start ${OUTPUT}

output:
	@echo ${OUTPUT}