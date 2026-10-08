# Shared pandoc/XeLaTeX toolchain for every book-writing-org project's build/release
# workflows. Canonically owned HERE (book-template), built and pushed by
# .forgejo/workflows/build-ci-image.yml whenever this file changes -- every project's
# book/adventures/release workflows just pull git.silvarion.org/book-writing/ci-tools:latest
# instead of each separately apt-get installing the same ~1GB of TeX Live packages on every
# single run. A project forked from this template should NOT also carry its own copy of this
# Dockerfile or build-ci-image.yml -- that would just rebuild and push the same shared tag
# redundantly on that project's own merges. Update the toolchain once, here, and every project
# picks it up next time any of them builds.
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    git \
    ca-certificates \
    pandoc \
    texlive-xetex \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    lmodern \
    zip \
  && rm -rf /var/lib/apt/lists/*
