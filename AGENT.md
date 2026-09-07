# AGENT.md - Project Overview

## Overview
This is a generic book-writing template based on Markdown files, compiled to PDF (via LaTeX/XeLaTeX) and EPUB using Pandoc.

## Directory Structure

```
.
├── chapters/                      # Book chapters, one Markdown file per chapter
│   └── 01-chapter-one.md          # Placeholder starting chapter
├── templates/                     # LaTeX compilation template
│   └── book.tex                   # Master LaTeX document
├── assets/                        # Supporting files
│   ├── images/                    # Image resources
│   └── styles/                    # Style configurations
├── build.sh                       # Build script (PDF + EPUB)
├── metadata.yaml                  # Book metadata (title, author, language, etc.)
└── .gitignore
```

## Workflow
1. Set the book's title, author, and language in `metadata.yaml`.
2. Add chapters as Markdown files in `chapters/`, prefixed with a sort-order number (e.g. `02-chapter-two.md`). Each chapter file starts with a YAML front matter block containing its `title`, followed by a level-1 heading and the chapter content.
3. Place images referenced by chapters in `assets/images/`.
4. Run `./build.sh` to compile the book into `output/book.pdf` and `output/book.epub`.

## Technical Notes
- Chapters are concatenated in filename order by `pandoc`, so numeric prefixes control chapter ordering.
- `templates/book.tex` is a generic Pandoc LaTeX template using the `book` document class, A4 paper with 1in margins, and `$title$`/`$author$`/`$body$` placeholders filled in from `metadata.yaml` and the chapter content.
- `build.sh` requires `pandoc` and a working `xelatex` installation (e.g. via a TeX distribution) to produce the PDF.
