# Neverland.lean — it compiles. That was never the proof.

A deliberate demonstration, built for education: a single small Lean 4
file (core Lean only, no Mathlib import) that contains a theorem named
`riemann_hypothesis` — and a second theorem proving it "false." Both
compile cleanly under Lean v4.35.0, and both depend only on the standard
axioms `[propext, Classical.choice, Quot.sound]`.

Neither theorem is about the Riemann zeta function. The file defines
its own shadow objects and rigs them three ways — the same three
definition tricks catalogued in our audit of the Alpöge GRH artifact:

1. **The conclusion inside the definition.** A "nontrivial zero" is
   *defined* as a zero that lies on the critical line.
2. **True slots consumed on-path.** The admissibility structure carries
   fields declared as `Prop := True`, required as hypotheses and
   discharged with `trivial`.
3. **Identity by copy.** "Height" and "length" are defined as the same
   expression, so their equality is `rfl`.

And the shadow zeta is a constant function that never vanishes — so
every statement about its zeros is vacuous, which is how the same file
"proves" the hypothesis and its negation.

The point is not that Lean is broken. The kernel is sound. The point is
that *it compiles* certifies only that a statement follows from its
definitions — and definitions can be built so the conclusion is already
inside them. A proof a mathematician cannot read is a certificate, not
a proof.

## Run it yourself

```
lean Neverland.lean
```

Expected output (see `neverland-compile-log.txt`):

```
'Neverland.riemann_hypothesis' depends on axioms: [propext, Classical.choice, Quot.sound]
'Neverland.riemann_hypothesis_is_false' depends on axioms: [propext, Classical.choice, Quot.sound]
'Neverland.height_eq_length' does not depend on any axioms
```

## Files

- `Neverland.lean` — the demonstration (read the header comment first)
- `ANNOTATIONS.md` — line-by-line notes on the three tricks
- `neverland-compile-log.txt` — the kernel's actual output

Background: the audit papers are on Zenodo —
[10.5281/zenodo.24489395](https://doi.org/10.5281/zenodo.24489395),
[10.5281/zenodo.24540196](https://doi.org/10.5281/zenodo.24540196),
[10.5281/zenodo.24564463](https://doi.org/10.5281/zenodo.24564463).
Live page: https://nuviratechnologies.io/neverland/

*Deliberate demonstration. Do not cite as mathematics.*
