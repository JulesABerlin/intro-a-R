# Interactive exercises: status & plan (updated 2 Oct 2026)

## Decisions (Jules)
- Restructure the site into a **Quarto book**, one chapter per session. Keep the URL https://julesaberlin.github.io/intro-a-R/ (it is tied to the repo name).
- Exercises go **after every session** (sessions 1–12), drawn from the 125-question Moodle bank. Each question gets a solution and an explanation.
- Problem Set sessions (3, 6, 9, 13) become **review chapters**, each with a full 20-question set.
- `reponses_socio.csv` will be replaced by a **synthetic copy** (same distributions and correlations, no real students). All data-based answer keys are recomputed from the published files.
- Disputed keys, resolved:
  - PS4 Q7 (ID 43): the correct answer becomes **e**, with an explanation of the misreading.
  - PS3 Q14 (ID 35): the rewrite replaced all options but kept the old key (b, d, e). **Restore the original Moodle options**, which match that key. Checked in R: 15 rows × 2 columns, mean 165.1 cm / 62.0 kg. a) is false: ?women says ages 30–39, while the option says 20–39.
  - PS3 Q18 (ID 34): the rewrite changed e) from "100 lignes" to "500 lignes" (true) but kept the key a, b, c, d. **Restore "100 lignes"**; the key then holds.
- reponses.csv (uploaded 2 Oct) is **byte-identical to reponses_socio.csv**: 74 rows, 10 variables, 16 Homme / 56 Femme / 2 Autre. The PS3 Q10 key "4 variables" therefore doesn't match. All keys get recomputed from the synthetic file, written without the row-name column.
- Jules agrees: remove the real reponses_socio.csv from the public repo and replace it with a synthetic copy.
- Work happens directly in the GitHub repo julesaberlin/intro-a-R, on a branch with a pull request for review. Nothing goes live until Jules merges and publishes.

## Pilot (PS1): DONE, confirmed working by Jules
- File: `claude/exercices_ch03_problemset1.qmd`.
- Webexercises CSS/JS are inserted from the installed package. webex.js already contains its own `<script>` tags, so it must not be wrapped again.
- `vf()` helper gives French Vrai/Faux dropdowns.
- Open TODO: the Q10 screenshot (problemset_1_images/ch_1_question_11.png) is missing.

## Deployment plan
- ~~Do NOT run `quarto publish` until `reponses_socio.csv` and the score files are replaced (step 4).~~ Done on 2 Oct 2026: `data/` now holds the synthetic survey and (since 5 Oct 2026) aggregate score distributions, and `_freeze/` was rebuilt from them and committed.
- The old single-page site files on `main` (`index.html`, `index_files/`, `index.pdf` and the other PDFs) still contain output from the real survey. Delete them once Pages serves the gh-pages branch, and decide with the data protection office whether to rewrite the git history.
- Run `quarto publish gh-pages`. This pushes only the built site to the gh-pages branch; then switch the Pages source to gh-pages once.
- Add a small redirect script so old `index.html#session-…` anchors land on the new chapter pages.
- Set `freeze: auto` so publishing doesn't re-run all the code.
- Data are served from the site, e.g. `read.csv("https://julesaberlin.github.io/intro-a-R/data/igposts.csv")`. This replaces the hard-coded paths like /Users/domus_julian/....
- Wrap exercises in `when-format="html"` blocks. The PDF/print manuscript for PPUR can then show solutions in an appendix.

## Data audit
- `reponses_socio.csv`: 74 students (birth year, gender, passport, origin, siblings, home town, commute, grades). Re-identification risk is high. → synthetic copy.
- Problem Set scores: only aggregate distributions are published (`distribution_ps_1–4.csv`: points, n). The row-level score files were removed on 5 Oct 2026.
- `igposts.csv`: surviving posts of the 2023 sample, metrics re-observed on 5 Oct 2026 (provenance in `data/README.md`). The old row-level file is no longer used.
- `reponses.csv` (PS3): not in the repo. Needed or must be replaced.
- The old files remain in the git history. If they must disappear, rewrite the history (git filter-repo). Check with the UniFR data protection office.

## Known issues in the source material
- Fenced divs aren't closed in the PS exercise files. `extensions: fenced_divs` is invalid YAML. Some options say "false" instead of "Faux".
- PS3 Q1 key says 230; the master key #66 says **6**.
- PS4 Q4 key is blank; the master key #74 says **4202**.
- PS4 Q16 and Q18 both carry ID 117.
- The problemset_X_images folders are missing. PS2 Q20 links directly to a figure on the live site.
- The 13 images in exercises_all.qmd reference unresolvable @@PLUGINFILE@@ paths.
- The PPUR proposal promises "100 exercices avec solutions". Keep a single question bank that serves both the site and the book.

## Next steps
1. Connect the repo. Recommended: the Claude desktop app's Code tab on the local clone, so R, CRAN and quarto preview all work locally. Alternative: claude.ai/code with the GitHub app.
2. DONE. Scaffold the book: add `_quarto.yml`, split index.qmd by session, run add_to_quarto, add the anchor redirects, and serve data from `data/`.
3. DONE. Build the question bank (YAML) plus a generator; map the 125 questions to sessions.
4. DONE. Generate the synthetic `reponses_socio.csv` and recompute the keys. Script: `data-raw/synthetiser_donnees.R` (reads the originals from the git-ignored `raw_data/`). Points files now hold points (and group) only.
5. Open a PR; Jules reviews, merges and runs `quarto publish gh-pages`.
