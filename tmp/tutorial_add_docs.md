---
layout: default
title: How to create a help document
parent: Documentation
nav_order: 1
---

# Tutorial: Adding New Documents to a Just the Docs Site
Our bioinformatics documentation is based on **Just the Docs** document template and gihtub pages. It has been setup in a way that when you upload properly structured documents to the github account, the documentation will automatically be updated. 
This guide explains how to add new documentation.

First you need to clone the documentation repository given [here](https://github.com/pirbright-bioinformatics/Documentation). The documentation structure looks like this:


```
docs/
├── Guides/
│   ├── 01_introduction_to_environments.md
│   ├── 02_advanced_reproducibility.md
│   └── index.md
└── HPC/
    ├── conda guide.md
    ├── index.md
    └── storage.md
....
....
....
```

Each folder represents a **section** (or parent page), and each Markdown file inside it is a **child page**.

---
## Format of the documentation
The documentation pages consists of markdown text (.md format) along with a header called the Front matter. Front matter starts and ends with three hyphens, and contains some directives on the structure of the current document. Information about the markdown syntax can be found [here](https://www.markdownguide.org/) and VScode supports it natively. If you use VScode, you can preview the rendering of the markdown as you enter it in real time.

<div style="font-family:monospace; background:#fff; padding:12px; border-radius:6px;">
<pre style="margin:0; line-height:1.35;"><span style="color:#d73a49;">---
layout: default
title: Sample Page
nav_order: 1
---</span><span style="color:#0366d6; display:block; margin-top:8px;">

# Sample Page

This is a short example showing front matter (above in red) and the Markdown content (this section in blue).
</span></pre>
</div>


## Step 1: Decide where the new page belongs

You can:
- Add a **new topic section** (a new folder under `docs/`)
- Or add a **new page** inside an existing section (like `Guides/` or `HPC/`)

Examples:
- To add a new section called “Analysis”: create a folder `docs/Analysis/`
- To add a new guide under “Guides”: add a new `.md` file in `docs/Guides/`

---

## Step 2: Create or update the folder structure

If you’re adding a **new section**, create both:

```
docs/Analysis/
docs/Analysis/index.md
```

If you’re adding to an existing section, skip this and go to **Step 3**.

---

## Step 3: Create the `index.md` file for a new section

If you’re adding a new folder (like `Analysis/`), you need an `index.md` file inside it.  
This acts as the **landing page** for that section and enables sidebar navigation.

Example (`docs/Analysis/index.md`):

```markdown
---
layout: default
title: Analysis
has_children: true
nav_order: 3
---

# Analysis

This section contains guides and documentation related to analysis workflows.
```

**Notes:**
- `layout: default` — uses the default Just the Docs layout  
- `title:` — the title that appears in the sidebar  
- `has_children: true` — required for nesting pages under this section  
- `nav_order:` — determines sidebar order (lower numbers appear higher)

---

## Step 4: Add a new document

Create a new Markdown file inside the appropriate section.

Example — adding a new page under **Guides**:

```
docs/Guides/03_reproducible_workflows.md
```

Front matter should look like this:

```markdown
---
layout: default
title: Reproducible Workflows
parent: Guides
nav_order: 3
---

# Reproducible Workflows

Explain the steps or concepts here...
```

**Notes:**
- `parent:` must exactly match the `title:` of the parent folder’s `index.md` (case-sensitive)
- `nav_order:` defines order **within** that section

---

## Step 5: Update navigation order (optional)

To control order in the sidebar, make sure each file under a section has a consistent `nav_order:` number.

Example (`docs/Guides/`):

| File | Title | nav_order |
|------|--------|-----------|
| 01_introduction_to_environments.md | Introduction to Environments | 1 |
| 02_advanced_reproducibility.md | Advanced Reproducibility | 2 |
| 03_reproducible_workflows.md | Reproducible Workflows | 3 |

---

## Step 6: Preview your documentation locally (optional)

There is a way to preview the documentation by compiling it locally. This was only tested in linux laptops, and is mentioned here only for documentation, as you might not be able to do it in the standard office machines. If you want to check your changes before pushing:

```bash
bundle install
bundle exec jekyll serve
```

Then open: [http://localhost:4000](http://localhost:4000)

You should see your new page in the sidebar under the appropriate section.

---

## Step 7: Commit and push

You need to get permissions to modify the official github repository first. Once you have the permission and satisfied with your documentation, push the changes to GitHub:

```bash
git add docs/
git commit -m "Add new documentation page: Reproducible Workflows"
git push
```

GitHub Pages (or your documentation hosting setup) will rebuild automatically.

---

## Example Result

After adding the new file, your structure might look like:

```
docs/
├── Guides/
│   ├── 01_introduction_to_environments.md
│   ├── 02_advanced_reproducibility.md
│   ├── 03_reproducible_workflows.md
│   └── index.md
└── HPC/
    ├── conda guide.md
    ├── index.md
    └── storage.md
```

And in the sidebar, you’ll now see:

```
Guides
├── Introduction to Environments
├── Advanced Reproducibility
└── Reproducible Workflows
HPC
├── Conda Guide
└── Storage
```

---

## Summary

| Task | Example | Required Front Matter |
|------|----------|-----------------------|
| New section | `docs/Analysis/index.md` | `has_children: true` |
| New page | `docs/Guides/03_reproducible_workflows.md` | `parent: Guides` |
| Ordering pages | `nav_order: <number>` | Optional but helpful |
| Sidebar grouping | `parent:` matches parent `index.md` `title:` | Yes |

---

## Template for a New Page (Child Document)

When creating a new document, start with this boilerplate:

```markdown
---
layout: default
title: Your Page Title Here
parent: Parent Section Name
nav_order: 1
---

# Your Page Title Here

_Optional subtitle or brief summary._

## Overview
Write a short introduction about what this document covers.

## Steps or Sections
1. Step one description  
2. Step two description  
3. Step three description

## Notes
- Add any warnings, best practices, or related links here.

---

[← Back to {{ page.parent }}](./index.html)
```

---

##  Template for a New Section (`index.md`)

Use this when creating a **new folder** (topic area) under `docs/`. Note that there will be an automatic table of content inserted to `index.md` after the front matter.

```markdown
---
layout: default
title: Section Name Here
has_children: true
nav_order: 5
---

# Section Name Here

This section contains documentation related to this topic.

## Overview
Write a brief description of what this section is about.

## Contents
- [Child Page 1](child_page_1.md)
- [Child Page 2](child_page_2.md)

---
```

---

## ️ Command-line Helper (Auto-create a Section and Page)

You can use the small Bash script `new_doc.sh` included in the git repo to automate creating new documentation folders and starter files.

###  Usage

```bash
./new_doc.sh "Section Name" "Page Title" 2 1
```

Where:
- `"Section Name"` → parent folder name (e.g., Guides, HPC, Analysis)
- `"Page Title"` → new Markdown page title
- `2` → nav order of the section
- `1` → nav order of the page


for example:

```bash
./new_doc.sh "Analysis" "Data Preprocessing" 3 1
./new_doc.sh "Analysis" "Visualization" 3 2
```

[← Back to Documentation](./index.html)
