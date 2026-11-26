# Neverland.lean — annotation

A deliberate demonstration by Kai Eluun (Muse, Meta), directed by
Richard Vigslist, 2026-11-26. Educational. Not a paper, not a claim.

## What the file does

One small Lean file (core Lean only, no Mathlib import) that proves a
theorem named the Riemann Hypothesis — and, from the same definitions,
a theorem that the Riemann Hypothesis is false. Compiled here with
Lean v4.35.0 (the same Lean version as the November 2026 GRH
artifact). Kernel accepts both. Compile log: `compile-log.txt`.

Axiom report, verbatim from the kernel:

- `Neverland.riemann_hypothesis` — [propext, Classical.choice, Quot.sound]
- `Neverland.riemann_hypothesis_is_false` — [propext, Classical.choice, Quot.sound]
- `Neverland.height_eq_length` — no axioms

That is the standard three-axiom profile — the same profile reported
for the artifact under audit. No `sorry`, no extra axioms, no tricks
at the kernel level. Every trick is at the definition level, which is
where the audit found them in the original.

## The three tricks, mapped to the audit findings

1. **The conclusion is inside the definition** (mirrors Finding 3 —
   the proved statement is weaker than its name). `NontrivialZero s`
   is defined as "a zero of the shadow zeta that lies on the critical
   line." The main theorem then "discovers" that every nontrivial
   zero lies on the critical line — by reading the definition back.

2. **`True` slots consumed on the proof path** (mirrors Findings 4
   and 6 — `anyGeometry := True` in OverIx.lean, `UnusedSlot72 :=
   True`). `AdmissibleData` carries `geometryCondition : Prop :=
   True` and `slot72 : Prop := True`; the central lemma requires both
   as hypotheses, in order, and callers discharge them with `trivial`.

3. **The hard identity is a copy** (mirrors Finding 5 — height and
   length closed by copy). `heightOf s := s.im` and `lengthOf s :=
   s.im` are presented as a spectral quantity and an independent
   geometric quantity; their identity closes by `rfl`.

And the shadow itself: `zetaShadow` is a constant function named
after the zeta function. It never vanishes, which is why the same
file can also prove every zero has real part 1/3. The kernel does not
know what ζ is. It only knows what the definitions say.

## The lesson, stated once

Lean is not broken. A kernel certificate proves that a statement
follows from definitions. It cannot prove that the definitions mean
what their names claim. "It compiles" settles the certificate. It
settles nothing about the mathematics. That gap is what the audit of
the November 2026 artifact documented at scale; this file reproduces
it in miniature, in the open, on purpose.
