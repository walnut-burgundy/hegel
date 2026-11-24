function fail(code, reason) {
    printf "FAIL %s %s\n", code, reason > "/dev/stderr"
    broken = 1
}

function canonical(line) {
    line = tolower(line)
    gsub(/[[:space:][:punct:]]+/, "", line)
    return line
}

function header(line) {
    gsub(/ /, "\t", line)
    return line
}

function register_input(case_id, variant, prompt, key, identity) {
    key = canonical(prompt)
    identity = case_id "/" variant
    if (key in prompt_identity)
        fail("duplicate-input", identity " repeats " prompt_identity[key])
    prompt_identity[key] = identity
    input_text[case_id, variant] = prompt
}

function register_answer(case_id, variant, verdict, answer, key) {
    key = case_id SUBSEP variant SUBSEP canonical(answer)
    if (key in answer_verdict && answer_verdict[key] != verdict)
        fail("contradictory-verdict", case_id " gives the same answer both verdicts")
    answer_verdict[key] = verdict
}

BEGIN {
    FS = "\t"
    headings["rules.tsv"] = header("rule_id revision path first_line last_line source_role")
    headings["cases.tsv"] = header("case_id failure_class objective input_or_fixture expected_outcome oracle grader_type required_evidence variant_family data_source split minimum_trials blocking")
    headings["prompts.tsv"] = header("case_id request common_facts primary_fact changed_fact distractor")
    headings["rubrics.tsv"] = header("case_id rule_id required_distinction missing_information prohibited_inference acceptable_primary acceptable_changed_fact")
    headings["examples.tsv"] = header("case_id variant verdict answer")
    count = split("material-constraints procedural-symmetry exception-alibis whole-interaction status-conditioned-charity motive-and-ambivalence irreversible-loss single-objective", classes, " ")
    for (i = 1; i <= count; ++i)
        is_class[classes[i]] = 1
}

FNR == 1 {
    table = FILENAME
    sub(/^.*\//, "", table)
    section = ""
    if (FILENAME ~ /\/development\//)
        section = "development"
    if (FILENAME ~ /\/reserved\//)
        section = "reserved"
    table_id = section "/" table
    if (++header_count[table_id] != 1 || !(table in headings) || $0 != headings[table])
        fail("header", FILENAME)
    columns = NF
    next
}

{
    if (NF != columns || $0 ~ /\r/) {
        fail("fields", FILENAME " line " FNR)
        next
    }
    for (field = 1; field <= NF; ++field) {
        if ($field == "" || $field ~ /^[[:space:]]|[[:space:]]$/)
            fail("field-content", FILENAME " line " FNR " column " field)
    }
}

table == "rules.tsv" {
    if ($1 !~ /^[a-z][a-z0-9-]*$/ || length($2) != 40 || $2 !~ /^[0-9a-f]+$/ ||
        $3 !~ /^[a-zA-Z0-9_-]+\.md$/ || $4 !~ /^[1-9][0-9]*$/ ||
        $5 !~ /^[1-9][0-9]*$/ || $4 + 0 > $5 + 0 || $6 != "repository-rule")
        fail("source-locator", $1)
    if (++rules[$1] != 1)
        fail("duplicate-rule", $1)
    next
}

table == "cases.tsv" {
    case_id = $1
    if (case_id !~ /^[a-z][a-z0-9-]*$/ || !($2 in is_class))
        fail("case-identity", case_id)
    if ($11 != "development" && $11 != "reserved")
        fail("split", case_id)
    if ($4 != $11 "/prompts.tsv#" case_id || $6 != $11 "/rubrics.tsv#" case_id)
        fail("case-path", case_id)
    if ($7 != "human-rubric" || $9 != "primary;changed-fact;distractor" ||
        $10 != "synthetic-policy-scenario" || $12 !~ /^[1-9][0-9]*$/ || $13 != "no")
        fail("case-metadata", case_id)
    if (case_id in case_split)
        fail("duplicate-case", case_id)
    case_split[case_id] = $11
    case_class[case_id] = $2
    ++coverage[$11, $2]
    next
}

table == "prompts.tsv" {
    case_id = $1
    if (case_split[case_id] != section || ++prompt_count[case_id] != 1)
        fail("prompt-identity", section "/" case_id)
    if ($0 ~ /rule_id|required_distinction|prohibited_inference|acceptable_primary|acceptable_changed_fact/)
        fail("answer-in-input", case_id " contains judge-side field text")
    context = $2 "\n\n" $3 "\n"
    register_input(case_id, "primary", context $4)
    register_input(case_id, "changed-fact", context $5)
    register_input(case_id, "distractor", context $4 "\n" $6)
    next
}

table == "rubrics.tsv" {
    case_id = $1
    if (case_split[case_id] != section)
        fail("rubric-identity", section "/" case_id)
    if (!($2 in rules))
        fail("missing-provenance", case_id "/" $2)
    if (++criterion_count[case_id, $2] != 1)
        fail("duplicate-criterion", case_id "/" $2)
    for (field = 3; field <= 7; ++field)
        judge_text[canonical($field)] = 1
    next
}

table == "examples.tsv" {
    case_id = $1
    if (case_split[case_id] != "development" || section != "development" ||
        ($2 != "primary" && $2 != "changed-fact") || ($3 != "pass" && $3 != "fail"))
        fail("example-identity", case_id "/" $2 "/" $3)
    if (++example_count[case_id, $2, $3] != 1)
        fail("duplicate-example", case_id "/" $2 "/" $3)
    register_answer(case_id, $2, $3, $4)
    judge_text[canonical($4)] = 1
    next
}

END {
    for (i = 1; i <= count; ++i) {
        kind = classes[i]
        if (!coverage["development", kind] || !coverage["reserved", kind])
            fail("class-coverage", kind " needs both splits")
    }
    for (case_id in case_split) {
        if (!prompt_count[case_id])
            fail("missing-prompt", case_id)
        if (!criterion_count[case_id, case_class[case_id]])
            fail("missing-provenance", case_id " lacks its class rule")
        if (case_split[case_id] == "development") {
            if (!example_count[case_id, "primary", "pass"] ||
                !example_count[case_id, "primary", "fail"] ||
                !example_count[case_id, "changed-fact", "pass"] ||
                !example_count[case_id, "changed-fact", "fail"])
                fail("missing-example", case_id)
        }
        ++case_count[case_split[case_id]]
    }
    for (prompt in prompt_identity)
        for (text in judge_text)
            if (text != "" && index(prompt, text))
                fail("answer-in-input", prompt_identity[prompt] " repeats judge-side text")
    if (emit_case != "" && !((emit_case SUBSEP emit_variant) in input_text))
        fail("unknown-prompt", emit_case "/" emit_variant)
    if (broken)
        exit 1
    if (emit_case != "")
        print input_text[emit_case, emit_variant]
    else
        printf "PASS corpus structure: %d development cases, %d reserved cases\n", case_count["development"], case_count["reserved"]
}
