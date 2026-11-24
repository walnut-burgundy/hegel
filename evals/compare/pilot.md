# Hegel reserved-case pilot

Pythia-410M-deduped produced 23 continuations. All reached the 96-token cap.
A second model rated the output with condition identities hidden. No answer
passed every applicable criterion. Sixteen failed at least one criterion
and seven ended without enough relevant analysis to score.

| Instructions | Prompts | Pass | Fail | Uncertain |
| --- | ---: | ---: | ---: | ---: |
| Baseline | 10 | 0 | 7 | 3 |
| Hegel | 10 | 0 | 6 | 4 |
| Hegel with Lacan | 3 | 0 | 3 | 0 |

The eight primary cases give the same totals under baseline and Hegel
instructions, with five failures and three uncertain answers each. The
matching totals conceal four changes. Night-route and workshop-access
went from uncertain to fail. Music-ensemble and orchard-contract went
from fail to uncertain. The two extra variants of the ensemble case
supply each of the first two rows' remaining observations. Lacan was
used only on the three ensemble variants.

- On evening-clinic, the baseline invented an employer's lack of awareness.
  With Hegel instructions, the model invented inconsistent shift end times.
  Neither answer used the supplied clinic closure and wage loss.
- On night-route, the baseline repeated the shared denominators without
  comparing the counts. With Hegel instructions, the answer repeatedly
  called the difference insignificant without addressing 27/50 versus 6/50.
- In the ensemble variant with documented shift overlaps, the Lacan
  condition echoed “A stated reason can be sincere and still incomplete”
  and still asserted that the player wanted to undermine the ensemble.
  It did not address the messages documenting the schedule conflicts.

The evening-clinic rubric's shared distinction mentions the reminder
problem supplied only in the changed-fact variant. The pinned prompt and
rubric were kept as published. The reviewer scored the primary answers
on the closure and wage facts and did not penalize omission of the reminder.

These are exploratory ratings from one model reviewer. The outcome measures
this base checkpoint, these prompt forms, and one greedy continuation per
condition. The single trial and pervasive token caps prevent a general claim
about instruction effects. No final score is claimed for the 153-observation
reserved profile.

## Evidence

- [Raw continuations](pilot-outputs.tsv) retains each token sequence and
  exact response. The final field escapes backslash, newline, carriage return,
  tab, and trailing space as `\\`, `\n`, `\r`, `\t`, and `\s`. Reconstruct the token file by adding
  a newline to the recorded IDs. The first ten fields reproduce the original
  observations table and identify the actual prompt, answer and token digests.
- [Rubric judgments](pilot-ratings.tsv) retains 32 criterion ratings and their
  reasons. Twenty-two failed and ten were uncertain. An answer fails if any
  criterion fails. An answer passes only if all its criteria pass.
- [Plan](pilot-plan.tsv) and [completion receipt](pilot-receipt.tsv) bind
  23 observations to the model, tokenizer, runtime packages and source.
  The [published runner tree](https://github.com/walnut-burgundy/hegel/tree/6e1df0ac1e7aec670fa302f0c9a5d15229ad5b33)
  is byte-identical to the local execution tree named in the plan.
- Ithon `d6e83969f82512e920fb17b44326cb54f31d015c` checked the whole module.
  Source SHA-256 is `de6b4ed1c46e6d845a6ab428005cafc11074d63196fe3666553cf70c2b413753`.
  Lowered source SHA-256 is `b8ce72d71a67f337e6d36282f777629e0fa4a15e98a64447c6b70bed258465a6`.
  The Grease runtime binary SHA-256 is
  `7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c`.
- Local attempts with the 1B checkpoint and 410M at batch size four ended
  with exit 137 and no complete observation record. The recorded pilot
  completed on x86-64 Linux with the 410M checkpoint, SDPA and batch size one.
