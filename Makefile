.PHONY: all serve build pdf epub mobi review clean

all: serve

serve:
	gitbook serve

build:
	gitbook build .

pdf:
	gitbook pdf . python-book.pdf

epub:
	gitbook epub . python-book.epub

mobi:
	gitbook mobi . python-book.mobi

review:
	open _book/index.html

clean:
	rm -rf _book/ _books/ book.epub book.mobi book.pdf
