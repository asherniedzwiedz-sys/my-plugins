---
name: apply
description: One-shot job application pass - analyze a job posting, tailor the resume, rewrite bullets, check ATS, write a cover letter and save the versions, deciding automatically whether the tech-resume optimizer fits the role. Use when the user runs /apply or asks to tailor a resume or write a cover letter for a job posting.
---

# /apply

Runs the resume-skills plugin (paramchoudhary/resumeskills) as one pipeline so the user doesn't call each skill by hand.

Usage: `/apply` plus a job posting (pasted text, a file or a URL). Options the user may add in plain words: "resume only", "cover letter only", "just analyze".

**Quick apply = resume only.** If the user says "quick apply", or the posting shows a quick-apply option (Quick Apply, Easy Apply, 1-click apply, Apply with resume, e.g. on LinkedIn, Indeed or Handshake), make only the tailored resume: skip the company research and cover letter (step 6). Note "Quick apply: resume only" in the first line of the output.

## Finding the resume

The user shouldn't have to attach the resume every time. Use the first one found:

1. A resume the user names, attaches or pastes in this message (this wins, even over a master).
2. A master resume in the working folder or its `Resumes/` subfolder: a file with "master" in its name (`.docx`, `.pdf` or `.md`); otherwise the most recently modified file with "resume" in its name, ignoring anything under `applications/`.
3. `~/Documents/Resumes/` (Asher's master lives at `Documents\Resumes\Asher_Niedzwiedz_Resume_MASTER.pdf`), then `~/Resumes/`, with the same rule. Use the real user folder (`C:\Users\<name>`), because HOME can point elsewhere on this PC.

If none is found, ask for it in one short question and suggest saving it in `Documents\Resumes\` with "MASTER" in the name so it's found automatically next time. If the posting is missing, ask for it. Say in one line which resume file was used.

## Rules that override every step

- Never invent experience, skills, tools, employers, dates or numbers. Reword and reorder what's there; don't add claims.
- Use only numbers already in the resume or that follow directly from its facts (counts, layer counts, team size, part numbers). Never invent or estimate a metric. When there's no real number, make the bullet strong without one (specific tools, scope and outcome) and move on. Don't ask the user for numbers or give them a list to fill in.
- Keep the user's resume format: a .docx comes back as a .docx with the same layout, a PDF source comes back as a .docx plus PDF, and plain text stays plain text.
- Never overwrite the original resume.

## Step 0: Decide whether the tech-resume optimizer applies

Read the posting's title, duties and required skills, then pick one:

| Role type | Examples | Tech optimizer |
|---|---|---|
| Software | software/SWE, web, backend, mobile, data/ML, DevOps, PM, QA automation | **Use it** for the whole resume |
| Hardware/EE | power, analog, RF, PCB/board design, test, validation, manufacturing, controls, semiconductor process, IC/ASIC physical design, field or applications engineering | **Skip it**. Its software framing (velocity, deploys, users) hurts these resumes |
| Mixed | embedded systems, firmware, FPGA/RTL, hardware-software integration, robotics, test automation for hardware | **Use it only** on the skills section and on bullets about code (C/C++, Python, RTOS, HDL); keep hardware bullets in hardware terms |

Decide from what the job actually does, not just the title. When the duties are mostly circuits, boards or lab work, treat it as Hardware/EE even if the title says "engineer". State the decision in one line at the top of the output, e.g. "Role type: Mixed (embedded firmware), so tech optimizer used on skills and code bullets only."

## The pipeline

Load each skill with the Skill tool as `resume-skills:<name>` and follow it for that step only. If the resume-skills plugin isn't installed, do the step yourself from the one-line goal given here and mention once at the end that installing resume-skills improves results.

1. **Analyze** (`job-description-analyzer`): extract required and preferred qualifications and keywords, score the match, and list the gaps. Stop here if the user said "just analyze".
2. **Tailor** (`resume-tailor`): reorder and reword sections and bullets to lead with what this posting cares about. Apply the Step 0 decision here (`tech-resume-optimizer` for Software, partially for Mixed).
3. **Strengthen bullets** (`resume-bullet-writer`): action verb, what was done, how, and the result. Apply the metrics rule above. Skip `resume-quantifier`, which estimates numbers.
4. **ATS check** (`resume-ats-optimizer`): confirm the posting's must-have keywords appear naturally where they're true, use standard section headings, and drop tables, text boxes and graphics that ATS parsers miss. List any must-have keyword the user genuinely lacks as a gap instead of adding it.
5. **Fill the resume page**: render the resume to PDF (Word via `docx2pdf`, or LibreOffice `soffice --headless --convert-to pdf`) and measure the blank space at the bottom of the last page (with pdfplumber: page height minus the lowest word's bottom, minus the bottom margin). If more than about 1 inch is empty, fill it, in this order:
   1. Bring back true content from the master that tailoring cut, most relevant to the posting first: bullets, projects, relevant coursework, lab tools and equipment, skills.
   2. Expand the most relevant bullets with real detail that's already in the master (tools, methods, scope).
   3. Only as a last resort, loosen the layout slightly: a little more space between sections, or body font up to 11 pt.
   Never invent content to fill space. Keep the same page count as the master (one page unless the master is longer), so nothing spills onto a new page. Re-render and repeat until the bottom gap is about half an inch or less.
6. **Cover letter** (`cover-letter-generator`; skip if the user said "resume only" or it's a quick apply):
   1. **Research the company** with WebSearch: what it makes, the team or division behind the role, recent products or news, and its stated mission or values. Use only facts the search turns up.
   2. **Write it**: one page at most, in normal business-letter layout. Cover why this company (specific, researched details, not generic praise), the two or three most relevant experiences from the resume told with more detail than the resume has room for, relevant coursework mapped to the job's duties, what Asher would bring to the team and learn from it, his availability or graduation date if the resume gives it, and a short close. Anything else that genuinely helps the case is welcome as long as it's true: company facts from the research, and experience or skills from the resume.
   3. **Humanize**: load `asher-skills:humanizer` in embedded mode on the letter so it doesn't read as AI-written, with no em dashes.
   4. **Fill check**: render it to PDF and find the lowest line of text. It must reach at least two thirds of the way down the page. If it's short, add more of the helpful content above, in this order: a deeper example from a project or course, a sharper tie between his experience and the role's duties, more specific company details from the research. Keep normal spacing (don't stretch the layout like the resume step), never invent experience, and keep it to one page. Re-run humanizer on new paragraphs, then re-check.
7. **Save versions** (`resume-version-manager`): keep the original untouched as the master. Save outputs under `applications/<Company>-<Role>/` next to the resume (or in the working directory):
   - `<Name>_Resume_<Company>.<ext>`
   - `<Name>_CoverLetter_<Company>.docx`
   - `notes.md` with the match score, gaps and the Step 0 decision

## Output to the user

Keep it short:

1. The role-type line from Step 0 and which resume was used
2. Match score and the top 3 gaps
3. The saved files (send them with SendUserFile when not running in Claude Code)

Don't recap each step.
