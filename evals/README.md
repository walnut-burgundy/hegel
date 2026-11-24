# Hegel reasoning cases

HEGEL-CASES-03 contains eight development cases and eight reserved evaluation
cases. Each split covers all eight failure classes. Each case has a primary
scenario, a changed fact that calls for a different judgment or degree of
confidence, and a distractor that leaves the primary judgment intact. The
development split includes a passing and failing answer for both the primary
and changed-fact variant of each case.

The scenarios and sample answers are synthetic. The rubric records cite
repository rules by exact revision, file, and line range in `rules.tsv`. The
vignettes contain no transcripts or attributed quotations. The `source_role`
column records the authority of the rule separately from the scenario's
`data_source`.

## Read and validate the corpus

`cases.tsv` uses the ai-ci evaluation-case manifest columns. Its file fragments
select rows by case ID within the named split. Each `rubrics.tsv` row is a
separately scored criterion. It states the distinction to preserve, missing
evidence, prohibited inference, and acceptable answers for the primary and
changed-fact scenarios. Judge the distractor with the primary criterion.

Invoke `check.grease` with Grease and the script's absolute path. With no
arguments it checks the tables. With two arguments it checks them and emits
one prompt on standard output. For example, the two arguments
`late-lab changed-fact` request that development prompt. Output consists
solely of the request and scenario evidence. Send those bytes to the worker.
Keep the corpus checkout on the evaluator side, including both rubrics and
worked answers. The reserved cases are public synthetic fixtures. Their
reservation concerns use in a run. Keep them out of development prompts,
tuning data, and general-purpose repository access given to a worker. For a
contamination-resistant evaluation of a model already trained on the public
corpus, hold fresh variants privately.

Invoke `self-test.grease` with Grease, using absolute paths for the script
and its single argument, the verified Grease executable. Use a Git checkout
that contains the two source revisions in `rules.tsv`. The self-test checks
the clean corpus and locators, independently compares emitted prompt bytes,
and confirms that the checker rejects a missing rule, conflicting labels for
the same answer and prompt, a prompt copied across splits, and rubric text
copied into a prompt. The checker compares normalized text for these controls.
Semantic paraphrases and answer quality require review.

## Score a run

Freeze the corpus revision and record the exact rule text used for each
condition. Run matched prompts with repository instructions and with the
decisive rule omitted or replaced. For each condition run the primary,
changed-fact, and distractor variants. Hold the worker, generation settings,
and unaffected instructions fixed. The manifest calls for three trials of
each comparison.

Give an evaluator the scenario, anonymous answer, and applicable rule and
rubric. Record `pass`, `fail`, or `uncertain` for each criterion with the
specific supplied evidence the answer uses or misses. A pass preserves the
required distinction, keeps its claims within the supplied evidence, and
avoids the prohibited inference. Accept any formulation within the stated
range. Record the answer's interpretation of the rule separately from the
judgment it makes about the scenario. Compare the judgments after checking
that the consequential fact changes the answer where specified and the
distractor leaves the substantive answer intact. An evaluator can use the
worked development answers to calibrate these decisions.

The corpus check establishes record consistency and the prompt boundary.
The worked labels are editorial judgments. Comparative model runs and
independently reviewed scoring belong to HEGEL-EVAL-04.
