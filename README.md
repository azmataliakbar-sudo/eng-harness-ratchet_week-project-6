# The Failure Classes — Harness Engineering Project 6

## Project Overview

Project 6 teaches **failure classes + the ratchet (Concept 10)**. Every agent mistake fits one of four classes:

| Class | Meaning | Where the fix goes |
|---|---|---|
| `didnt_know` | Agent didn't have the info | skill / knowledge |
| `wasnt_stopped` | Agent wasn't blocked | permission / guardrail |
| `wasnt_checked` | Agent wasn't verified | gate / test |
| `planned_badly` | Agent's approach was wrong | spec / plan |

The **ratchet**: turn each mistake into a permanent harness fix, so the same shape becomes impossible.

## Why we simulate a week in seconds

The assignment says "seven days." A week is just 7 batches of mistakes. We run all 7 days in one command with no waiting — the pattern is the same.

## Project Structure

```
failure_classes/
├── .git/
├── classify.ps1      # maps a mistake to one of 4 classes
├── ratchet.ps1       # applies the fix + logs one line
├── run-week.ps1      # simulates 7 days, counts per class
├── HARNESS.md        # one line per fix
├── reset.ps1
└── README.md
```

## Test Commands

```powershell
.\reset.ps1
.\run-week.ps1
```

## The 7-Day Result

| Class | Count |
|---|---|
| didnt_know | 1 |
| wasnt_stopped | 2 |
| wasnt_checked | 1 |
| planned_badly | 1 |
| Blocked by ratchet | 2 |

**Thinnest class (dominated): `wasnt_stopped` (2).**

## What the Ratchet Proved

- Day 1: "read secret" → `wasnt_stopped` → add guardrail.
- Day 3: same "read secret" → **RATCHET HELD** (blocked, no new failure).
- Day 4: "skipped test" → `wasnt_checked` → add gate.
- Day 6: same "skipped test" → **RATCHET HELD**.

Two failures with the same shape became impossible after the first.

## Harness Parts Used

- **Failure classes** — the four boxes for classifying mistakes.
- **The ratchet** — permanent fix after each mistake.
- **Observability** — HARNESS.md logs one line per fix.
- **Trace** — each day shows mistake → class → fix.

## The Lesson

Classify every mistake, fix it in that class's surface, and the same shape never happens twice. The class that dominates tells you where your harness is thinnest.

## What Is the Ratchet, Exactly?

The ratchet is a **habit**, not one single file:

- Every mistake becomes a permanent fix.
- The fix lives in a different "surface" depending on the class:
  - `didnt_know` → skill file
  - `wasnt_stopped` → permission/guardrail
  - `wasnt_checked` → gate/hook
  - `planned_badly` → spec/plan

In this simulation, `ratchet.ps1` logs the fix into `HARNESS.md` as a stand-in for actually editing the real rule. In a real system, you would edit the actual guardrail/skill/gate/spec file.

## Why Did a Mistake Repeat?

The repeats are **planted on purpose**:

- Day 3 repeats "read secret" to prove the Day 1 guardrail holds.
- Day 6 repeats "skipped test" to prove the Day 4 gate holds.

When the same shape appears again, it is **blocked** (`RATCHET HELD`), not counted as a new failure. That is how we verify the earlier fix made the mistake impossible.

## Test Commands (Confirmed)

Run from the project folder:

```powershell
cd C:\Projects\eng_harness\failure_classes
.\reset.ps1
.\run-week.ps1
```

Expected: 7 days printed, `wasnt_stopped` dominates (2), and 2 repeat shapes are blocked.

## Project Status

- Four classes defined: ✅
- 7 days simulated: ✅
- Ratchet blocks repeats: ✅
- Thinnest class named: ✅

STATUS: COMPLETE
