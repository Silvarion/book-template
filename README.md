# book-template

A generic, batteries-included template for writing a book in Markdown and compiling it to PDF (via Pandoc + XeLaTeX) and EPUB — with optional, additive support for a Spanish translation mirror, standalone TTRPG adventure modules derived from the book's Parts, and a dual-game-system split for those modules' mechanical content.

Nothing here is mandatory beyond `chapters/` and `metadata.yaml`. Everything else — translations, adventures, multiple game systems, CI — is opt-in and ignored by the build until you actually add it.

## Features

- **Markdown in, PDF + EPUB out.** One `./build.sh` away from a finished book, via Pandoc and a plain, readable XeLaTeX template.
- **Optional Spanish translation mirror** (`translations/es/`), same filenames as `chapters/`, built as a parallel `_es` output — or any language, really; "es" is just this template's worked example.
- **Optional standalone adventure modules** (`adventures/<part-slug>/`) for a TTRPG-adjacent book whose Parts are sized to sell as their own product, independent of the novel's own chapters.
- **Optional dual-game-system split** for an adventure module's mechanical content (e.g. Pathfinder 2e and the D&D 5e SRD side by side), system-neutral narrative kept separate from each system's crunch.
- **Skips, not fails.** Any language, adventure, or system with no content yet is printed as `(skip)`, not an error — a fresh fork builds cleanly on day one with nothing but a placeholder chapter.
- **Forgejo Actions CI, ready to use.** A tag-triggered `release.yml` builds everything and publishes it as a Forgejo Release with zipped PDF/EPUB assets — no editing required after forking. A shared `pandoc`/`XeLaTeX` toolchain image (built once, here, not re-built per project) keeps every consuming workflow fast.

## Prerequisites

- [Pandoc](https://pandoc.org/)
- A working XeLaTeX installation (e.g. [TeX Live](https://tug.org/texlive/))

Both are already baked into this org's shared `git.silvarion.org/book-writing/ci-tools` image if you're building via the included Forgejo Actions workflows — you only need them installed locally if you want to run `./build.sh` on your own machine.

## Quick start

1. **Fork or copy this template** into a new repository.
2. **Set your book's details** in `metadata.yaml` (title, author, language). Add `metadata.es.yaml` too if you're translating.
3. **Write.** Replace `chapters/01-chapter-one.md` and add more chapters as `chapters/02-…md`, `chapters/03-…md`, etc. — numeric prefixes control build order. Each file starts with a small YAML front-matter block (`title: "…"`) followed by a level-1 Markdown heading and the chapter text.
4. **Build it:**
   ```
   ./build.sh novel
   ```
   PDF and EPUB land in `output/`.

That's the entire minimum path. Everything below is additive, for when you need it.

## Build commands

```
./build.sh novel               # the novel: output/book.pdf + .epub (en), _es variants (es)
./build.sh adventures          # each Part-adventure, once per system it has content for
./build.sh bundle              # all Part-adventures concatenated into one adventure-path PDF/EPUB
./build.sh all                 # all of the above
./build.sh <subcommand> en|es  # restrict to one language (default: both)
```

## Directory structure

```
.
├── chapters/              # Book chapters, English/original, one Markdown file per chapter
├── translations/es/       # Optional Spanish mirror of chapters/
├── adventures/            # Optional standalone TTRPG modules, one per Part
│   └── <part-slug>/
│       ├── metadata.yaml
│       ├── sessions/      # System-neutral session content
│       └── <system>/      # Optional per-system mechanical crunch (any folder name)
├── templates/             # LaTeX compilation templates (book.tex, adventure.tex)
├── assets/                # Images, styles, and optionally characters/NPCs/enemies
├── build.sh               # Build script
└── metadata.yaml          # Book metadata (title, author, language)
```

See [`AGENTS.md`](./AGENTS.md) for the complete reference: the full directory layout, the language/format/system model, the step-by-step workflow, and the CI setup — written for both human contributors and AI coding agents working in this repo.

## CI and releases

Forking this template brings in a `release.yml` that needs no editing: push a tag matching `v*` (e.g. `git tag v0.1.0 && git push origin v0.1.0`) and it builds everything, zips the results, and publishes a Forgejo Release — automatically scoped to whichever repo it runs in. You'll need a repo secret `RELEASE_TOKEN` (a Forgejo access token with `write:repository` scope) for that step to publish.

A project with its own regular build-on-merge workflows (one per deliverable, triggered on push to `main`) should add those itself, following the pattern in a sibling project like `heir-of-doom` — this template doesn't prescribe that part, since it depends on what you're actually shipping.

`build-ci-image.yml` and its Dockerfile build the shared toolchain image every project in this org pulls from. **They live here, canonically, and should not be copied into a forked project** — see `AGENTS.md`'s CI section for why.

## License

This template's tooling and scaffolding — `build.sh`, the LaTeX templates, the Forgejo Actions workflows, and the directory structure/conventions they implement — are licensed under the **GNU Affero General Public License v3.0** (see [`LICENSE`](./LICENSE)).

In plain terms: if you take this template, improve or extend its *tooling* (the build script, the CI workflows, the LaTeX layouts, etc.), and distribute that modified version to anyone — including by running it as a network service — you're required to make your changes to that tooling available under AGPL-3.0 too.

**This does not extend to the book you write with it.** The chapters, adventures, and any other creative content you add under `chapters/`, `translations/`, `adventures/`, or `assets/` are your own work. Using this template to write and publish a book — including selling it — does not place your book's text under AGPL, or under any obligation to share it. Only modifications to the template's own tooling and scaffolding are covered.

If you're unsure where a specific change falls (e.g. a build.sh feature that's tightly coupled to your book's own structure), the safest read is: changes that would be useful to *any* project using this template are tooling, and belong back upstream; content that's specific to *your* book is yours.
