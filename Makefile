.PHONY: all build pdf epub mobi review update clean

all: serve

serve:
	gitbook serve

build:
	gitbook build .

pdf:
	gitbook pdf . python_book.pdf

epub:
	gitbook epub . python_book.epub

mobi:
	gitbook mobi . python_book.mobi

review:
	open _book/index.html

clean:
	rm -rf _book/ _books/ book.epub book.mobi book.pdf
