# Hegel model comparison

HEGEL-EVAL-04 reads the checked scenarios from [the corpus](../README.md).
The worker receives the request and scenario facts. It has no tools and
receives neither reference answers nor grades. Each prompt starts with the
same instruction to ground a short answer in the facts. The Hegel condition
adds the 18 required checks from the pinned human-reasoning guardrails and
the pinned Hegel/Lawvere passages on relation, asymmetry, and descriptive
claims. The Lacan condition adds excerpts on stated intentions, conflicting
motives, repetition, and interpretation under uncertainty. It applies to
the ensemble case. The runner reads all excerpts from immutable Git objects.

## Reproduce

Use a checkout containing corpus commit
`5652264d189e36ba20b4af1accf064cf45525641` and the two repository
rule revisions named in `run.pi`. Use the [Ithon host frontend at
d6e83969](https://github.com/dilapidated-shed/ithon/tree/d6e83969f82512e920fb17b44326cb54f31d015c)
with a Python 3.12 environment containing the packages in `model.tsv`. The
frontend checks the complete Ithon module before executing it. PyTorch
and Transformers provide the foreign runtime for local model inference.
The local checkpoint and tokenizer must match the locked byte digests.
Use the verified Grease runtime for the corpus prompt emitter. The run
does not download anything or require credentials.

Call the Ithon executable with the absolute path to `run.pi` and then
`run pilot MODEL_DIR GREASE RUN_DIR`. Use absolute paths for the model
directory, Grease executable, and new output directory. Set
`ITHON_CHECK_RECEIPT` to capture the frontend evidence. The pilot uses
23 greedy observations. It covers every reserved primary case under two
conditions and includes the changed-fact and distractor variants and Lacan
condition for the ensemble case. The `reserved` profile uses all 153
observations, three paired samples per prompt with seeds 29, 31, and 37.
Both profiles use the frozen Pythia-410M-deduped base model from Gym's
[BME checkpoint baseline](https://github.com/fuego-ironworks/gym/actions/runs/45456057977).
They cap each response at 96 new tokens, check for finite scores, and use
BF16 with SDPA and two CPU threads. Each request uses batch size one.
Paired rows in the sampling profile start from the same seed without
sharing draws with other rows.

To check an existing run, replace `run` with `verify` and keep the same
profile, material paths, and run directory. The verifier checks the whole
planned matrix, exact prompt bytes, file hashes, token counts, stop reasons,
and completion marker. A killed run may retain material but lacks a validated
completion receipt. Invoke `self-test.grease` with the verified Ithon
executable, model directory, Grease executable, and a complete pilot
directory to exercise the positive run and five targeted refusals. These
checks establish receipt consistency. Independent verification of inference
requires reproducing a run from the pinned input material.

## Results

The [pilot result](pilot.md) presents output and a separate rubric review.
Repeated trials and end-to-end scoring for the full reserved profile remain
open. The runner emits token IDs, decoded answers, rendered prompts, and
generation settings. Assessors can review the decoded answers without being
shown which instructions produced them.
