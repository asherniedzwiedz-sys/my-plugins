---
name: "clean"
description: "Rewrite AI-sounding prose with the humanizer skill, then strip AI provenance metadata (C2PA/EXIF/XMP), hidden Unicode and dashes from a file or text the user owns. Use when the user runs /clean."
---

# /clean

One pass that does both: it rewrites the prose (humanizer) and strips the hidden marks and metadata (github.com/guillaumemeyer/watermarks-remover, MIT). Clean files and text the user owns. Keep any disclosures that school, work or a platform requires, and never claim the result is undetectable.

Modes:
- `/clean <text or file>`: full pass (humanize, then clean).
- `/clean --no-rewrite ...`: metadata, Unicode and dash cleanup only, with the wording kept as is.

## 1. Humanize the prose (text and editable docs only)

Skip this step for images, PDFs, `--no-rewrite`, or code-only content.

Load the `humanizer` skill with the Skill tool and follow it in **embedded mode**: run its whole process but keep only the final text. If the user gave a writing sample, use it as the voice. Leave code, commands, paths, citations, numbers and quotes unchanged. For DOCX, rewrite the paragraph text with python-docx and keep the formatting. For MD/HTML, rewrite only the prose.

If the humanizer skill isn't available, apply its core rules yourself: no "not X but Y" lines, no one-line closers, no forced lists of three, no dashes, no stock AI words, no bold labels, no chatbot filler, and no new facts.

## 2. Get the repo

If `~/watermarks-remover` (or `/home/claude/guillaumemeyer/watermarks-remover`) has no git checkout, clone it:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/guillaumemeyer/watermarks-remover "$HOME/watermarks-remover"
```

If cloning fails, use add_repo for guillaumemeyer/watermarks-remover first.

## 3. Start the service

```bash
cd "$HOME/watermarks-remover"   # or wherever it was cloned
curl -sf http://127.0.0.1:8765/health || (nohup python3 service/scripts/server.py --host 127.0.0.1 --port 8765 > /tmp/wm.log 2>&1 &); sleep 4
curl -sf http://127.0.0.1:8765/health
```

If health still fails, show the tail of /tmp/wm.log and stop.

## 4. Clean

Run this on the output of step 1 (or on the original file when step 1 was skipped), so the cleaner also catches anything the rewrite introduced.

- **File** (image, PDF, DOCX, MD, HTML...): base64 it and POST to `/clean`, then decode `cleaned` into `<name>.clean.<ext>`:

```bash
WM=http://127.0.0.1:8765
B64=$(base64 -w0 "$FILE")
curl -s -X POST "$WM/clean" -H 'Content-Type: application/json' -d "{\"file\":\"$B64\",\"name\":\"$(basename "$FILE")\"}" > /tmp/wm_out.json
python3 -c "import json,base64,sys;d=json.load(open('/tmp/wm_out.json'));assert d.get('ok'),d;open(sys.argv[1],'wb').write(base64.b64decode(d['cleaned']));print(json.dumps(d.get('report'),indent=1)[:1500])" "$OUT"
```

- **Pasted text**: write it to a temp .txt file and send it through `/clean` the same way.
- For an audit without changes, POST to `/inspect` instead of `/clean`.

`GET /capabilities` shows which optional tools are installed (exiftool, c2patool). If a needed tool is missing, say what it couldn't strip.

## 5. Final dash and quote check (always)

The repo leaves em dashes (—) and en dashes (–) in place, so check the final text:

- **Text/MD/HTML/DOCX**: rewrite any sentence still containing — or –, using a comma, period, colon, parentheses or "and", whichever reads naturally. Keep the hyphens in ranges like 3-5 and in compound words. Swap curly quotes for straight ones unless the user's sample uses curly. Confirm with `grep -c '[—–]'` that the count is 0.
- **Images/PDFs**: skip this step, since the text is not editable.

## 6. Deliver

For pasted text, return only the final text in a copyable block, with no draft or pattern list. For a file, send the cleaned file with SendUserFile and add one line on what was removed. Keep it brief.