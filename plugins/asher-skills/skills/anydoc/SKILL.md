---
name: anydoc
description: Convert Word, PowerPoint, Excel, OpenDocument, RTF, EPUB, CSV and PDF files to Markdown with firecrawl/anydoc, falling back to Microsoft markitdown for images, audio, HTML, ZIP and YouTube. Use when the user runs /anydoc or a task needs the contents of an office document, spreadsheet, slide deck, ebook or PDF.
---

# anydoc: documents to Markdown

From github.com/firecrawl/anydoc (MIT). Run the CLI. It needs Node 20+ and nothing to install:

```bash
npx -y @firecrawl/anydoc <file>              # Markdown to stdout
npx -y @firecrawl/anydoc <file> -o out.md    # write to a file
npx -y @firecrawl/anydoc - --format csv < f  # read stdin
```

Rules:

1. Supported inputs: `.doc`, `.docx`, `.docm`, `.odt`, `.rtf`, `.epub`, `.pdf`, `.ppt`, `.pps`, `.pot`, `.pptx`, `.pptm`, `.ppsx`, `.ppsm`, `.odp`, `.xls`, `.xlsx`, `.xlsm`, `.xlsb`, `.ods`, `.csv`.
2. The format is detected from the file content. Pass `--format <name>` only when detection can't work: CSV from stdin, or a missing or wrong extension.
3. Exit codes: 0 success, 1 couldn't convert, 2 usage error, 3 PDF pages need OCR. Failures print one `anydoc: <message>` line to stderr.
4. For a large document, write it to a file with `-o` and read only the parts you need, instead of streaming everything into context.
5. Scanned or image-only pages need OCR, which anydoc doesn't do locally (exit 3). Ask the user before rerunning with `--ocr hosted`, because that uploads the document to Firecrawl's servers. Otherwise read the pages as images yourself.
6. Work on a copy of the user's file, never the original.
7. Inside a Node, Python or Rust codebase, use the library instead of the CLI: `@firecrawl/anydoc` (npm), `firecrawl-anydoc` (PyPI) or `anydoc` (crates.io), each with a `to_markdown` / `toMarkdown` API.

## When anydoc can't do it: markitdown

Use Microsoft's `markitdown` (installed by Asher's install script with `uv tool install "markitdown[all]"`) for what anydoc doesn't cover, or when anydoc fails: images (EXIF and text), audio (transcription), HTML, ZIP files, JSON/XML, Outlook messages and YouTube URLs.

```bash
markitdown <file-or-url> -o out.md
```

If `markitdown` isn't on PATH, run `uvx --from "markitdown[all]" markitdown <file>`.

## Delivering

When the user just wants the Markdown, save it as `<name>.md` next to the original and say where it is, plus one line on what's in it. When the conversion is a step in a bigger task (summarizing, extracting numbers, answering questions), use the Markdown silently and answer the actual question.
