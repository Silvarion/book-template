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

## CI (Forgejo Actions)

`.forgejo/ci-image/Dockerfile` + `.forgejo/workflows/build-ci-image.yml` build and publish `git.silvarion.org/book-writing/ci-tools:latest` — a shared pandoc/XeLaTeX/zip toolchain image every project in this org's build and release workflows pull, instead of each `apt-get install`-ing the same ~1GB of TeX Live packages from scratch on every single run.

**This repo (book-template) is the canonical, single owner of that Dockerfile and workflow.** A project forked from this template should bring in its own `build-book.yml`/`build-adventures-*.yml`-style workflows (whatever it actually needs, pulling the shared image), but should **not** also carry a copy of `build-ci-image.yml` or the Dockerfile — every project doing that would redundantly rebuild and push the identical shared tag on its own merges. Update the toolchain once, here, and every project picks it up next time any of them builds. Requires a repo secret `REGISTRY_TOKEN` (Forgejo access token, `write:package` scope) to push; the `ci-tools` package needs to be set public in the registry (one-time) so other projects can pull it without credentials.

**`release.yml` ships ready to use, with no project-specific editing needed.** Triggered by pushing a tag matching `v*` (e.g. `v0.1.0`), or run by hand from the Actions tab. Runs `./build.sh all`, zips the results into two generic assets — `book.zip` (the novel, both languages) and `adventures.zip` (every adventure/bundle output, whatever systems and languages actually exist — broad globs, not named per system, since a forked project's system folder names aren't known ahead of time) — and uploads them to one Release for that tag via the `forgejo-release` action. The target repo (`owner/repo`) is resolved automatically from `${{ github.repository }}`, so forking this template into a new repo needs no edits here. **Requires a repo secret `RELEASE_TOKEN`**: a Forgejo access token with `write:repository` scope.
- Because Forgejo Actions reads a tag-triggered workflow's file from that tag's own commit, a fix to `release.yml` only helps tags created *after* the fix lands on `main`. To retry a tag that already failed, re-point it at a commit with the fix (`git tag -f vX.Y.Z <commit> && git push --force origin vX.Y.Z`) rather than expecting the merge alone to fix it.
- If `build.sh`'s own `BOOK` variable is ever renamed away from the default `"book"`, update the matching literal in `release.yml`'s "Package release assets" step too — they're not wired together, just conventionally kept in sync.

**Suggested tagging scheme, three phases** (a default worth adopting as-is; adjust the phase boundaries to the project's actual chapter count):
1. **Drafting — `v0.0.<n>`.** `n` is the number of the latest chapter merged into `main` with its prose done (e.g. `v0.0.3` once chapter 3 lands). Runs until every planned chapter is drafted.
2. **Revision — `v0.<m>.<p>`.** `m` is the number of chapters that are fully revision-complete (proofread, illustrated, adventure-module ready, assets in place); `p` increments at whatever point within the next chapter's revision makes sense to cut a release — a chapter can be mid-revision at a tag, it just needs to be at a coherent, publishable state.
3. **Done — `v1.0.0`.** Cut once every chapter is fully revision-complete — the finished book.
- Cut a release by tagging a commit on `main` once it's ready: `git tag v0.0.1 && git push origin v0.0.1`.

## Technical Notes

- Chapters/sessions are concatenated in filename order by `pandoc`, so numeric prefixes control ordering.
- `templates/book.tex` is a generic Pandoc LaTeX template using the `book` document class, A4 paper with 1in margins, and `$title$`/`$author$`/`$body$` placeholders filled in from metadata and content.
- `templates/adventure.tex` is currently a placeholder copy of `book.tex` — replace it with a real module layout when one is designed.
- `build.sh` requires `pandoc` and a working `xelatex` installation (e.g. via a TeX distribution) to produce PDFs.
- A chapter/session file with front matter `title: "SUPERSEDED"` is skipped by the build — a convention for marking old files that should be deleted but couldn't be (e.g. left behind by a rename done by tooling without delete access).
- A session's optional system-crunch companion is matched purely by filename (`sessions/01-x.md` ↔ `pf2/01-x.md`) — keep them numbered identically or the pairing silently drops the unmatched side. The same filename-pairing applies to any character/NPC/creature files a project adds under `assets/`.
