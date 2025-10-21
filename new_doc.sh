#!/usr/bin/env bash
# Create a new section (if needed) and page for Just the Docs documentation

SECTION="$1"
PAGE_TITLE="$2"
SECTION_ORDER="${3:-1}"
PAGE_ORDER="${4:-1}"
DOCS_DIR="docs"

if [[ -z "$SECTION" || -z "$PAGE_TITLE" ]]; then
  echo "Usage: $0 \"Section Name\" \"Page Title\" [section_order] [page_order]"
  exit 1
fi

# Convert section and title to folder/file friendly names
SECTION_DIR="$DOCS_DIR/${SECTION// /_}"
PAGE_FILE="${PAGE_TITLE// /_}.md"

mkdir -p "$SECTION_DIR"

# Create index.md if missing
if [[ ! -f "$SECTION_DIR/index.md" ]]; then
  cat <<EOF > "$SECTION_DIR/index.md"
---
layout: default
title: $SECTION
has_children: true
nav_order: $SECTION_ORDER
---

# $SECTION

This section contains documentation related to $SECTION.
EOF
  echo " Created section index: $SECTION_DIR/index.md"
fi

# Create the page file
cat <<EOF > "$SECTION_DIR/$PAGE_FILE"
---
layout: default
title: $PAGE_TITLE
parent: $SECTION
nav_order: $PAGE_ORDER
---

# $PAGE_TITLE

_Describe the purpose of this document here._

## Overview
Write an introduction or summary.

## Details
Provide steps, code snippets, or explanations here.

---

[← Back to $SECTION](./index.html)
EOF

echo " Created new page: $SECTION_DIR/$PAGE_FILE"
