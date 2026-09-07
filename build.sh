#!/bin/bash

BOOK="book"

mkdir -p output

echo "Building PDF..."

pandoc chapters/*.md \
  metadata.yaml \
  --from markdown \
  --template=templates/book.tex \
  --pdf-engine=xelatex \
  --resource-path=.:assets/images \
  --citeproc \
  -o output/book.pdf

echo "Building EPUB..."

pandoc chapters/*.md \
  metadata.yaml \
  --from markdown \
  --toc \
  --epub-chapter-level=1 \
  --resource-path=.:assets/images \
  --citeproc \
  -o output/book.epub

echo "Done ✔"