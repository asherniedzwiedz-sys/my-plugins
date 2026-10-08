---
name: apply
description: One-shot job application pass - analyze a job posting, tailor the resume, rewrite bullets, check ATS, write a cover letter and save the versions, deciding automatically whether the tech-resume optimizer fits the role. Use when the user runs /apply or asks to tailor a resume or write a cover letter for a job posting.
---

# /apply

Runs the resume-skills plugin (paramchoudhary/resumeskills) as one pipeline so the user doesn't call each skill by hand.

Usage: `/apply` plus a job posting (pasted text, a file or a URL) and the resume (a file, a path, or the master resume from an earlier run). Options the user may add in plain words: "resume only", "cover letter only", "just analyze".

If the posting or the resume is missing, ask for it in one short question and stop.

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
5. **Cover letter** (`cover-letter-generator`): one page, specific to this company and role, drawn only from the resume and the posting. Then load `humanizer` (from this same plugin, `asher-skills:humanizer`) in embedded mode on the letter so it doesn't read as AI-written, with no em dashes. Skip if the user said "resume only".
6. **Save versions** (`resume-version-manager`): keep the original untouched as the master. Save outputs under `applications/<Company>-<Role>/` next to the resume (or in the working directory):
   - `<Name>_Resume_<Company>.<ext>`
   - `<Name>_CoverLetter_<Company>.docx`
   - `notes.md` with the match score, gaps and the Step 0 decision

## Output to the user

Keep it short:

1. The role-type line from Step 0
2. Match score and the top 3 gaps
3. The saved files (send them with SendUserFile when not running in Claude Code)

Don't recap each step.
