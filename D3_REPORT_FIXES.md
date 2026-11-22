# Deliverable III report: proofreading fixes to apply

Purpose: bring the Deliverable III report (`F26-104_Deliverable-3_Report.pdf`) in line with the evaluator's formatting rules and with the latest facts recorded in `Manzil_FYP_Context.md` §50, `PLAN.md` and `results/*/README.md`.

These fixes were first applied to the frozen copy `fyp-kaam-D3`. Apply the same changes in the original `fyp-kaam` repository so the two stay in step.

## How to apply

- Edit only the LaTeX source in `Manzil_D2_Report/` (`main.tex` and `chapters/*.tex`).
- Rebuild with `Manzil_D2_Report/build.ps1`. If PowerShell stops on MiKTeX's update notice, run `pdflatex`, then `bibtex`, then `pdflatex` twice, from bash. The output is `Manzil_D2_Report/build/main.pdf`.
- Run `..\.venv\Scripts\python check_report.py` from `Manzil_D2_Report/`.
- Copy the build to `F26-104_Deliverable-3_Report.pdf`.
- Each item below quotes the current source text ("Find") and gives the replacement ("Replace"). Section and page numbers refer to the 149-page PDF dated 22 November 2026.
- Do **not** make these changes. They were reviewed and deliberately excluded:
  - Overlapping text in the sequence diagrams (Figures 6.3–6.5)
  - Small text in the dashboard screenshots (Figures 8.1–8.4) and the Figure 9.3 chart
  - Unused abbreviations (CV, MOT, OSM, MDP, MARL, IDF1, IoU) and terms written out after definition
  - Blank areas on pages
  - Hyphenation and spacing in narrow table columns
  - Mixed single and double spacing between tables
  - British vs American spelling
  - The "five decisions" wording in the Chapter 3 intro
  - The near-duplicate paragraphs in 6.4.7 and 6.7.3

---

## A. Required fixes

### A1. Table 8.1: commands print without spaces (p. 117, `chapters/08_user_manual.tex`)
**Cause:** `\path{...}` (url package) drops spaces, so `--profile medium --seed 0` prints as `--profilemedium--seed0`.
**Fix:** replace each `\path{...}` in the table with `\texttt{...}`. Escape `_` as `\_`, and write `--` as `-{}-` so it does not turn into an en dash. Example:
`\texttt{manzil.experiments.runner -{}-profile medium -{}-seed 0}`
Rows to change: One run, Controller comparison, Comparison statistics, Routing and corridor, DQN training, Tests.

### A2. ER diagrams: overlapping labels (Figures 4.8–4.11, pp. 45–47, `chapters/04_srs.tex`, TikZ blocks after `\label{fig:er}` … `\label{fig:er-emergency}`)
Move attribute ovals and cardinality labels so nothing overlaps:
- Figure 4.8 (overview): ovals cover the region titles ("Experiment Configuration and Evidence", "Observation and Control Evidence"); the "0..*" labels touch the entity boxes; the Emergency region has a large empty bottom half. Move the titles above the ovals, give the cardinalities clear space, and shrink the empty part of the Emergency region.
- Figure 4.9: `scenario_id` overlaps `network_version`; `seed` overlaps `controller_version`.
- Figure 4.10: `video_job_id` overlaps `clip_checksum`; `observation_id` overlaps `run/job_id (FK)`.
- Figure 4.11: the `mission_id` oval overlaps the region title; "0..*" overlaps the EmergencyMission box.

### A3. Figure 6.6 corridor state diagram (p. 81, `chapters/06_design.tex`, TikZ before `\label{fig:corridor-state}`)
- The arrow from REQUESTED down to CANCEL/FAILURE runs straight through the text "SAFE TRANSITION". Route it so it does not cross the node.
- The "safe fallback" label sits on the CANCEL/FAILURE → RECOVERY arrow. Move it above or below the arrow.
- Applied version (in the D3 copy):
  - `\draw[arr] (trans.south) -- node[pos=.8,left,font=\scriptsize]{cancel/fail} ([xshift=-4mm]cancel.north);`
  - `\draw[arr] ([xshift=-6mm]active.south) -- ++(0,-5mm) -| ([xshift=6mm]cancel.north);`
  - `\draw[arr] (cancel)--node[above,font=\scriptsize,align=center]{safe\\fallback}(recover);`

The ER figures were redrawn in the D3 copy at 15.5 cm wide in `\scriptsize`. The simplest way to carry them over is to copy the four `tikzpicture` blocks for `fig:er`, `fig:er-experiment`, `fig:er-observation` and `fig:er-emergency` from `fyp-kaam-D3/Manzil_D2_Report/chapters/04_srs.tex`.

### A4. Remove sentences that refer to the sample or reference report, or read as template text
| Where | Find | Replace |
|---|---|---|
| 4.3 (`04_srs.tex`) | "The quality model for Manzil follows the sample report's separation between broad software qualities and individually testable non-functional requirements." | "Manzil's quality model separates broad software qualities from the individually testable non-functional requirements." (this wording avoids an overfull line) |
| 4.3.3 | "…does not introduce public user registration merely because sample reports contain account modules." | "…does not introduce public user registration." |
| 4.7.2 | "Table 4.12 follows the sample report's responsibility-oriented presentation: each technology is tied to a task and to a configuration item that must be recorded." | "In Table 4.12 each technology is tied to a task and to a configuration item that must be recorded." |
| 4.8 | "The interface specification follows the sample report by defining the screen inventory and navigation before presenting individual wireframes." | "The interface specification defines the screen inventory and navigation before presenting individual wireframes." |
| 4.9.1 | "Following the notation used in the reference report, Figure 4.8 presents…" | "Figure 4.8 presents…" |
| 10.3 (`10_conclusion.tex`) | "The future work is the plan for FYP-II, which is mandatory for FYP-I." | "This section gives the plan for FYP-II." |

The 4.7.2 sentence was not in the original proofreading list. It was found in the source during the edit and removed for the same reason.

---

## B. Contradictions, fixed to match the notes

### B1. Seeds (5.8.2, `05_methodology.tex`)
Source of truth: §50 and `PLAN.md` record FYP-I experiments on evaluation seeds 0–4. The ten-seed protocol is FYP-II work.
- Find: "These values were kept unchanged for every FYP-I controller comparison."
- Replace: "The 900-second warm-up and 3,600-second measurement interval were kept for every FYP-I controller comparison."
- Keep the final sentence about five seeds (0 to 4) instead of ten.

### B2. Downstream capacity is not implemented (`05_methodology.tex`, `03_literature.tex`)
Source of truth: no downstream check in `manzil/corridor/coordinator.py`. `PLAN.md` W4 lists it as todo.
- 5.6, Find: "Activation considers estimated arrival, standing queue clearance, signal state, and downstream capacity rather than distance alone." Replace: "Activation considers estimated arrival, standing queue clearance, and signal state rather than distance alone."
- 5.6, Algorithm 2 paragraph: delete the whole sentence "The downstream-capacity check and compensation during recovery are planned for FYP-II." (the user asked for both lines to be removed).
- Same paragraph, Find: "Ordinary-traffic harm is bounded through maximum priority duration, downstream occupancy checks, and maximum-red monitoring," Replace: "Ordinary-traffic harm is bounded through maximum priority duration and maximum-red monitoring,"
- 3.2.4.2, Find: "It also uses look-ahead activation, timeout, downstream checks, and bounded priority duration." Replace: "It also uses look-ahead activation, timeout, and bounded priority duration."
- Leave alone: 9.7 Limits ("downstream-capacity check … not implemented") and Table 10.2 item 5 are accurate. The literature-table wording about downstream-capacity checks describes the cited paper, not Manzil.

### B3. Cross-references for the 5 s corridor minimum (5.6, Algorithm 2 paragraph)
- Find: "…and the choice of the 5 s corridor minimum is discussed in Chapter 9."
- Replace: "…and the measured effect of the 5 s corridor minimum is reported in Chapter 9."
- Find: "…are never shortened; Chapter 7 gives the reason." Replace: "…are never shortened; Chapter 7 explains why this change was kept."

### B4. Cross-street queueing (9.6, `09_results.tex`)
Source of truth: §50 corridor_v2 entry and `results/phase3/corridor_v2/README.md` ("+4 to +14 %"). 7.1.6 already says 4 to 14.
- Find: "raised cross-street queueing by 7 to 14 percent" → Replace: "raised cross-street queueing by 4 to 14 percent".

### B5. Storage is file-based in FYP-I (6.4.6 and 6.7.5.3, `06_design.tex`)
Source of truth: `PLAN.md` ("Results stored as files first … A database … comes in FYP-2"). There is no database or migration code in `manzil/`.
- 6.4.6, Find: "Schema migrations, referential constraints, immutable completed-run configuration, and versioned metrics protect comparison integrity." Replace: "Immutable completed-run configuration and versioned metrics protect comparison integrity; schema migrations and referential constraints are part of the FYP-II database design."
- 6.4.6, Find: "The database records identifiers and provenance for external artifacts…" Replace: "Run manifests record identifiers and provenance for external artifacts…"
- 6.7.5.3, Find: "The store uses schema migrations and referential constraints for structured configuration, events, missions, routes, and metrics, while large videos…" Replace: "In FYP-I the store writes structured configuration, events, missions, routes, and metrics as versioned files, and the FYP-II database will add schema migrations and referential constraints, while large videos…"

### B6. Section 3.2 subheadings renamed to match their content (`03_literature.tex`)
Only the `\subsubsection{}` titles change; the paragraphs stay as they are.
| Now | New title |
|---|---|
| 3.2.1.1 Research Overview | One-Stage Detection |
| 3.2.1.2 Critical Assessment | Multi-Object Tracking |
| 3.2.1.3 Relevance to Manzil | Traffic Datasets and Relevance to Manzil |
| 3.2.2.1 Research Overview | Fixed-Time Baseline |
| 3.2.2.2 Critical Assessment | Max-Pressure Control |
| 3.2.2.3 Relevance to Manzil | (unchanged) |
| 3.2.3.1 Research Overview | Deep RL for Signal Control |
| 3.2.3.2 Critical Assessment | Pressure-Based and Multi-Agent Methods |
| 3.2.3.3 Relevance to Manzil | Simulator Choice |
| 3.2.4.1 Research Overview | Shortest-Path Algorithms |
| 3.2.4.2 Critical Assessment | Emergency Preemption |
| 3.2.4.3 Relevance to Manzil | (unchanged) |

Also update the intro of 3.2.1. Find: "The subsections below give the research overview, a critical assessment, and the relevance of each source to the implemented pipeline." Replace: "The subsections below review one-stage detection, multi-object tracking, and the traffic datasets used for evaluation." The intros of 3.2.2–3.2.4 already match the new titles.

### B7. Precision claim (9.2, `09_results.tex`)
Source of truth: `results/vision/README.md` has overall precision only (0.748 → 0.889); per-class precision on UA-DETRAC was not recorded.
- Find: "…mainly through a large gain in precision for cars and buses."
- Replace: "…mainly through higher precision (0.748 to 0.889) and higher mAP50 for cars and buses."

### B8. Objective O2 (2.4, `02_vision.tex`)
- Find: "Evaluate a pretrained vehicle detector with multi-object tracking…" Replace: "Fine-tune a pretrained vehicle detector and evaluate it with multi-object tracking…" (this wording avoids an overfull line).

### B9. 12 % is the overall WAPE, not a per-clip figure
- Executive Summary (`main.tex`), Find: "counts vehicles with an average error of about 12 percent." Replace: "counts vehicles with an overall error of about 12 percent."
- 9.7 (`09_results.tex`), Find: "counts vehicles with an error of about 12 percent per clip on public video" Replace: "counts vehicles with an overall count error (WAPE) of about 12 percent on public video".

---

## C. Smaller formatting and wording

### C1. List of Figures entry 9.1: page number runs into the title
Give Figure 9.1 a short List of Figures entry. Find `\caption{Precision--recall curves of the fine-tuned detector on the UA-DETRAC test sequences}` and replace it with `\caption[Precision--recall curves of the fine-tuned detector]{Precision--recall curves of the fine-tuned detector on the UA-DETRAC test sequences}`.

### C2. Table 10.1 placement (10.2, `10_conclusion.tex`)
Table 10.1 must appear before the bullet list, not split the third bullet. Use `\begin{table}[H]` (the `float` package is loaded) and keep it right after the paragraph "Table 10.1 gives the status…" and before "In summary, the following work was completed:". Add `\setstretch{1}` after `\centering`: an `[H]` table is not a real float, so without it the table picks up the 1.5 body line spacing.

### C3. Definition lists stick out into the left margin (1.3 and 3.1)
The `description` lists print their labels about 0.45 em left of the text margin. Fix the list options in `01_introduction.tex` and `03_literature.tex` so labels start exactly at the margin, then check the result on pages 2 and 11.

### C4. Table 9.4 difference column has no unit (`09_results.tex`)
Header "DQN $-$ fixed (95\,\% CI), seeds better" → "DQN $-$ fixed (s) (95\,\% CI), seeds better".

### C5. Chapter 1 intro (`01_introduction.tex`)
Find: "…from work that remains planned for FYP-II, because the evaluators asked for working code and the report must not blur that boundary." Replace: "…from work that remains planned for FYP-II, and the report keeps that boundary clear."

### C6. Sentences that describe the layout
- 3.3: delete "The table uses wrapped columns and continues across portrait pages, which preserves legibility without rotating a page or treating unlike evidence as a common numerical ranking."
- 7.2, Find: "…which are therefore stated once in every table header row:" Replace: "…which are repeated in the header rows of every table:"

### C7. Tense
- 3.2.1.3, Find: "Manzil should use licensed public sequences where they support reproducible evaluation and may add a small, separately documented local sample if collection permission and annotation effort are feasible." Replace: "Manzil uses licensed public sequences, mainly UA-DETRAC, for reproducible evaluation, and a small, separately documented Lahore sample is planned for FYP-II."
- 5.2.1, Find: "A selected, manageable Lahore road area will be exported from OpenStreetMap…" Replace: "In FYP-II, a selected, manageable Lahore road area will be exported from OpenStreetMap…"

### C8. DQN and YOLO defined where first used
They are used from Chapter 1 onward but defined only in 3.1. Move both entries from the 3.1 list into the 1.3 list, in alphabetical order (DQN before "Double DQN", YOLO before "YOLO11s"), and delete them from 3.1.

---

## After applying
1. Rebuild and run `check_report.py`.
2. Recheck these pages: 2, 11, 12–18 (3.2 headings), 45–47, 59–60, 81, 117, 122, 126–127, 129–130, and the List of Figures.
3. Copy the build over `F26-104_Deliverable-3_Report.pdf`.
4. Per `CLAUDE.md`: add a session-log line in `PLAN.md` and a §50 note in `Manzil_FYP_Context.md`, then commit and push.
