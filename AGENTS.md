# AGENT.md - Project Overview

## Overview
This is a generic book-writing template based on Markdown files, compiled to PDF (via LaTeX/XeLaTeX) and EPUB using Pandoc. It also scaffolds three optional, additive extensions that the trilogy repos (`heir-of-doom`, `heir-of-fate`, `heir-of-glory`) use: a Spanish translation mirror, a set of standalone TTRPG adventure modules derived from the book's Parts, and a dual-game-system split for those modules' mechanical content. All three are opt-in — a project that doesn't need them can ignore `translations/`, `adventures/`, and the `*.es.yaml` files entirely and use `./build.sh novel` alone, same as the old single-language, novel-only workflow.

## Directory Structure

```
.
├── chapters/                      # Book chapters, English/original, one Markdown file per chapter
│   └── 01-chapter-one.md          # Placeholder starting chapter
├── translations/
│   └── es/                        # Optional Spanish mirror of chapters/ — same filenames, translated content
├── adventures/                    # Optional standalone sellable TTRPG modules, one per Part (not per chapter)
│   └── <part-slug>/
│       ├── metadata.yaml          # English adventure metadata
│       ├── metadata.es.yaml       # Spanish adventure metadata
│       ├── sessions/              # English session content — system-neutral if using the system split below
│       ├── <system>/              # Optional: mechanical crunch for one game system, same filenames as sessions/
│       │                          #   (e.g. pf2/, dnd5e-srd/ — any folder name works, see System below)
│       └── translations/es/       # Spanish mirror of sessions/
├── templates/                     # LaTeX compilation templates
│   ├── book.tex                   # Novel layout
│   └── adventure.tex              # TTRPG-module layout — currently a PLACEHOLDER (a straight copy of book.tex);
│                                   # a real module layout (boxed read-aloud text, stat blocks, sidebars) isn't designed yet
├── assets/                        # Supporting files
│   ├── images/                    # Image resources
│   └── styles/                    # Style configurations
│                                   # A project with named characters/NPCs/creatures can add its own
│                                   # characters/, non-playable-characters/, enemies/ folders here and apply
│                                   # the same optional system split (see System below and heir-of-doom's AGENT.md
│                                   # for the worked example) — narrative file plus same-named pf2/, dnd5e-srd/ companions.
├── build.sh                       # Build script — see Build commands below
├── metadata.yaml                  # Book metadata, English (title, author, language, etc.)
├── metadata.es.yaml               # Optional book metadata, Spanish
└── .gitignore
```

## Language and format model

- **Language:** `chapters/` (and each adventure's `sessions/`) is the English original and should never be moved or renamed. A Spanish translation is a parallel file of the *same name* under `translations/es/` (book level) or `adventures/<slug>/translations/es/` (adventure level). Metadata mirrors the same way: `metadata.yaml` (English) / `metadata.es.yaml` (Spanish). Everything Spanish is additive — add `translations/es/` and `metadata.es.yaml` when you want a translation; until then the build just skips that language.
- **Format:** a **Part is the sellable adventure-module unit**, not a chapter — a Part is a run of several chapters/sessions with its own arc, sized to sell as a standalone TTRPG product. `adventures/<part-slug>/` holds that module's own metadata and session content, independent of whichever novel chapters it's derived from.
- **System (optional):** if publishing for more than one game system, keep `sessions/` system-neutral (setup, read-aloud text, GM notes — no mechanical stats) and add one sibling folder per system (any name — the trilogy repos use `pf2/` and `dnd5e-srd/`) holding a same-named companion file per session. `build.sh` discovers whichever system folders exist per adventure automatically and builds one output per system, interleaving each session with its companion; an adventure with no system folders yet just builds narrative-only — nothing has to be added until a second system is actually being written. The same split applies to any character/NPC/creature files added under `assets/`: a system-neutral narrative file plus same-named companions under that folder's per-system subfolders for the mechanical stats, referenced (never duplicated) from `adventures/`.

## Workflow

1. Set the book's title, author, and language in `metadata.yaml` (and `metadata.es.yaml` if translating).
2. Add chapters as Markdown files in `chapters/`, prefixed with a sort-order number (e.g. `02-chapter-two.md`). Each chapter file starts with a YAML front matter block containing its `title`, followed by a level-1 heading and the chapter content.
3. Place images referenced by chapters in `assets/images/`.
4. To translate a chapter, create the same filename under `translations/es/` with translated content and front matter.
5. To turn a Part into a sellable adventure module, create `adventures/<part-slug>/` with its own `metadata.yaml` (+ `metadata.es.yaml`) and write session content into `sessions/` (+ `translations/es/` when translating). To publish that module for more than one game system, add a same-named companion file under a per-system folder (e.g. `pf2/01-x.md` alongside `sessions/01-x.md`) for each system, keeping `sessions/` itself system-neutral.
6. Run `./build.sh` — see Build commands below.

## Build commands

```
./build.sh novel               # the novel: output/book.pdf + .epub (en), _es variants (es)
./build.sh adventures           # each Part-adventure, once per system it has content for:
                                #   output/adventures/<part-slug>_<lang>_<system>.pdf + .epub
                                #   (falls back to output/adventures/<part-slug>_<lang>.pdf if no system folder yet)
./build.sh bundle               # all Part-adventures concatenated, same per-system naming
./build.sh all                  # all of the above
./build.sh <subcommand> en|es    # restrict to one language (default: both)
```

Any language, adventure, or system with no content yet is skipped (printed as `(skip)`), not treated as an error — a fresh project forked from this template builds cleanly with nothing but `chapters/01-chapter-one.md` and `metadata.yaml` in place.

## Technical Notes

- Chapters/sessions are concatenated in filename order by `pandoc`, so numeric prefixes control ordering.
- `templates/book.tex` is a generic Pandoc LaTeX template using the `book` document class, A4 paper with 1in margins, and `$title$`/`$author$`/`$body$` placeholders filled in from metadata and content.
- `templates/adventure.tex` is currently a placeholder copy of `book.tex` — replace it with a real module layout when one is designed.
- `build.sh` requires `pandoc` and a working `xelatex` installation (e.g. via a TeX distribution) to produce PDFs.
- A chapter/session file with front matter `title: "SUPERSEDED"` is skipped by the build — a convention for marking old files that should be deleted but couldn't be (e.g. left behind by a rename done by tooling without delete access).
- A session's optional system-crunch companion is matched purely by filename (`sessions/01-x.md` ↔ `pf2/01-x.md`) — keep them numbered identically or the pairing silently drops the unmatched side. The same filename-pairing applies to any character/NPC/creature files a project adds under `assets/`.
