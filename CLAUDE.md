# Medical Calc (working title) — notes for Claude Code

Flutter Android health calculator for Pakistan, English only, offline, no login. Opens with a mode selector: **Doctor** (28 clinical tools) or **Public** (10 self-checks). Design: `docs/medical-calc-design-v0.1.md` (draft, decisions in Section 14). Research behind it: `reports/Health calculator tools for app.md` and `research_notes/`.

## Places
- Root `/mnt/storage/projects/medical_calc`; backup `scripts/backup.sh` → `/mnt/storage/project_backups/medical_calc_backup` (local only; no Drive folder yet).
- Git: `AwaizFatima08/medical_calc` (**public** — never commit keystores, key.properties or other secrets; keep them in `../medical_calc-secrets/`).
- Package `com.homilabs.medicalcalc`.
- Web pages: `web/medicalcalc/` → `https://tools.homilabs.org/medicalcalc/` (Hostinger), plus a card on tools.homilabs.org's home page. Other apps' folders there are live — never touch them.
- AdMob account homilabs.smc@gmail.com: app ID `ca-app-pub-2087846699268567~1518498085`, banner `ca-app-pub-2087846699268567/7044101590`; debug builds use the Google test banner. No ads on calculator, result, red-flag or onboarding screens (design 6.1).

## Rules
- **No formula, factor or threshold is coded until it is checked against its primary source**, has golden vectors in `test/golden/<id>.json`, and is signed off by the reviewing doctor in `docs/calculator-register.md` (design Section 9).
- Results are reference bands with the source, version and review date — never treatment instructions. No drug dosing in release 1.
- MMSE and MoCA are excluded (licence).
- Heavy builds go through `jobq` (see ~/.claude/heavy-jobs.md); `cd android && ./gradlew --stop` after building.
- Test phones: Samsung A12 and Oppo (see takhti_grow memory for adb details). After each build: install, run, debug, rebuild.
