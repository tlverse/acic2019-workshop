TITLE=handbook

.PHONY: all
all: book clean

book:
	Rscript -e "bookdown::render_book('.')"

clean:
	rm $(TITLE).Rmd

