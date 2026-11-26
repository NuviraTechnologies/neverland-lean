/-!
# Neverland.lean

A deliberate demonstration, built on purpose by Kai Eluun (Muse, Meta)
at the direction of Richard Vigslist, 2026-11-26.

This file "proves" the Riemann Hypothesis. It also "proves" that the
Riemann Hypothesis is false. Both proofs are accepted by the Lean
kernel, and neither depends on any axiom beyond the standard three.

Nothing in this file is mathematics about the real Riemann zeta
function. Every object below is a private shadow of the real one.
That is the point: a kernel certificate attests that a *statement*
follows from *definitions* — it cannot attest that the definitions
mean what their names claim. When the definitions are rigged, the
certificate is perfect and the mathematics is Neverland.

Each construction below mirrors a finding from the audit of the
November 2026 GRH artifact (see ANNOTATIONS.md in this folder):

* Trick 1 — the conclusion is smuggled into the definition of the
  objects (audit Finding 3: the statement is weaker than its name).
* Trick 2 — hypotheses the proof "consumes" are slots defined to be
  `True` (audit Findings 4 and 6: `anyGeometry`, `UnusedSlot72`).
* Trick 3 — two quantities presented as independently computed are
  the same term twice, so the key identity closes by `rfl`
  (audit Finding 5: height and length defined by copy).

Do not cite this file as mathematics. Cite it as a demonstration.
-/

namespace Neverland

/-- Shadow complex numbers: pairs of rational numbers. Not ℂ. -/
structure CNum where
  re : Rat
  im : Rat
deriving DecidableEq, Repr

/-- Our private "zeta function". It is not the Riemann zeta function;
    it is a constant. Nothing in the kernel will ever object to the
    name. -/
def zetaShadow : CNum → CNum
  | _ => ⟨1, 0⟩

/-- A point is "on the critical line" when its real part is `1/2`. -/
def OnCriticalLine (s : CNum) : Prop :=
  s.re = 1 / 2

/-! ## Trick 1 — the conclusion lives inside the definition

A "nontrivial zero" is *defined* to be a zero of `zetaShadow` that
lies on the critical line. The theorem below therefore does not
discover where the zeros are; the definition has already decided. -/

/-- "Nontrivial zeros" of the shadow zeta function. -/
def NontrivialZero (s : CNum) : Prop :=
  zetaShadow s = ⟨0, 0⟩ ∧ OnCriticalLine s

/-! ## Trick 2 — `True` slots on the proof path

The central lemma *requires* a geometry condition and a slot-72
condition as hypotheses. They sit on the path, they are consumed by
name, and they are `True` by construction, so any caller discharges
them with `trivial`. -/

/-- The "admissible data" consumed by the main construction. -/
structure AdmissibleData where
  conductor : Nat
  geometryCondition : Prop := True
  slot72 : Prop := True

/-- The standard admissible data, with both conditions in place. -/
def standardData : AdmissibleData where
  conductor := 5040
  geometryCondition := True
  slot72 := True

/-- The central lemma. Every hypothesis is used, in order, exactly
    as a serious development would use them. -/
theorem central_lemma (d : AdmissibleData)
    (_hgeom : d.geometryCondition) (_h72 : d.slot72)
    (s : CNum) (hs : NontrivialZero s) : s.re = 1 / 2 := by
  obtain ⟨-, hline⟩ := hs
  exact hline

/-! ## Trick 3 — the hard identity is a copy

The "height" of a zero is computed on the spectral side; the
"length" is computed independently on the geometric side. The
identity between them — the analytic heart of the argument —
closes by `rfl`, because both definitions are the same term. -/

/-- The height of a zero, from the spectral side. -/
def heightOf (s : CNum) : Rat := s.im

/-- The length of a zero, from the geometric side. -/
def lengthOf (s : CNum) : Rat := s.im

/-- The height–length identity. -/
theorem height_eq_length (s : CNum) : heightOf s = lengthOf s := rfl

/-! ## The main theorems -/

/-- **The Riemann Hypothesis.** Every nontrivial zero of the zeta
    function lies on the critical line. -/
theorem RiemannHypothesis (d : AdmissibleData)
    (hgeom : d.geometryCondition) (h72 : d.slot72) :
    ∀ s : CNum, NontrivialZero s → s.re = 1 / 2 :=
  fun s hs => central_lemma d hgeom h72 s hs

/-- The Riemann Hypothesis, for the standard data. -/
theorem riemann_hypothesis :
    ∀ s : CNum, NontrivialZero s → s.re = 1 / 2 :=
  RiemannHypothesis standardData trivial trivial

/-- **The Riemann Hypothesis is false.** From the same definitions,
    every nontrivial zero has real part `1/3`. This also compiles,
    because `zetaShadow` never vanishes: there are no nontrivial
    zeros, so every statement about all of them is true. The kernel
    certifies both theorems with the same indifference. -/
theorem riemann_hypothesis_is_false :
    ∀ s : CNum, NontrivialZero s → s.re = 1 / 3 := by
  intro s hs
  obtain ⟨hzero, -⟩ := hs
  have h1 : zetaShadow s = ⟨1, 0⟩ := rfl
  rw [h1] at hzero
  exact absurd hzero (by decide)

end Neverland

/-! ## The certificates

Run this file through Lean and read what the kernel itself reports:
both "theorems" depend on exactly the standard three axioms —
`propext`, `Classical.choice`, `Quot.sound` — the same axiom profile
as the artifact this demonstration mirrors, and the height–length
identity depends on none. The certificates are flawless. The
mathematics is Neverland. That gap is the whole lesson. -/

#print axioms Neverland.riemann_hypothesis
#print axioms Neverland.riemann_hypothesis_is_false
#print axioms Neverland.height_eq_length
