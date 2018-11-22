TITLE = "proposal_acic2019"

.PHONY : all
all: doc clean

doc:
	pdflatex $(TITLE).tex
	pdflatex $(TITLE).tex

clean:
	rm -f $(addprefix $(TITLE),.aux .bbl .blg .fff .log .out .mw)
	rm -f $(addprefix sections/*,.aux .bbl .blg .fff .log .out .mw)

