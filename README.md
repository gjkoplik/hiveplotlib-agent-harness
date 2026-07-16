# hiveplotlib-agent-harness

Building an agent harness to improve agentic independence on Hiveplotlib software development and research.

Intended use: a submodule of Hiveplotlib used in correspondence with an adjacent [Hiveplotlib LLM Wiki](https://github.com/gjkoplik/hiveplotlib-llm-wiki) submodule.

## How it works

The dispatching session (the consumer-repo Claude Code conversation the maintainer types into) is the sole dispatcher: every sub-agent is invoked from it, sub-agents never invoke each other, and every report returns to it for the maintainer to see. The plan file is the shared memory the agents coordinate through.

```mermaid
flowchart TD
    M([Maintainer]) <--> DS["Dispatching session<br/>(sole dispatcher, no direct edits)"]
    DS -. "runs inline<br/>(skill, not a sub-agent)" .-> GRILL["grill-me<br/>brief interview + plan grill"]
    DS --> ORCH["orchestrator<br/>writes & amends the plan"]
    DS --> ADV["adversary<br/>attacks the plan, then the ship"]
    DS --> SPEC["specialists<br/>code / test / docs / notebook"]
    DS --> CRIT["critics<br/>api / viz / editorial"]
    DS --> QA["qa-engineer<br/>release-readiness gate"]
    DS --> RL["research-liaison<br/>wiki in (pre-task), wiki out (ADRs, analyses)"]
    ORCH --> PLAN[("plan file<br/>shared memory; each agent<br/>writes only its own sections")]
    ADV --> PLAN
    SPEC --> PLAN
    CRIT --> PLAN
    QA --> PLAN
```

Rough order for a coding task: grill-me brief interview (optional) → research-liaison pre-task → orchestrator plans → adversary challenges → grill-me grills → per workstream: specialist → critics → adversary post-impl → qa-engineer → research-liaison closes out to the wiki. A research run swaps the specialists for a bounded panel of parallel research lenses, with the same adversary/grill spine.

### The build loop (autonomous coding)

How code actually gets built: a generate-evaluate loop (the evaluator-optimizer shape from Anthropic's *Building Effective Agents*, with the roles split further). A plan-hardening loop runs before any code exists; then each workstream flows specialists → reviewers, with the two big loops drawn as back-edges: `must-fix` findings route back through the orchestrator for amend-and-re-dispatch (drawn once from qa to keep the diagram clean; a `must-fix` from any reviewer takes the same edge), and a clean workstream cycles to the next until the plan is done (qa also has a self-fix micro-loop, noted in its box). Within a workstream the session dispatches the relevant specialists in order (test-engineer follows code-engineer) and only the reviewers the surface calls for. Under auto-dispatch ("run it through") the pauses between workstreams are removed but every gate still runs; the run halts to the maintainer on `must-fix`, `BLOCKED`, or a finding that bears on a downstream workstream.

Arrows show the logical hand-off order; physically, every dispatch is made by the dispatching session (the hub above), which is how each agent keeps a clean context.

```mermaid
flowchart TD
    M([maintainer brief]) --> ORCH

    subgraph PLAN["plan loop (no code yet)"]
        ORCH[orchestrator] -- "drafts plan" --> ADV1["adversary<br/>(cold challenge)"]
        ADV1 --> GRILL["grill-me<br/>(alignment + failure modes)"]
        GRILL -. "amendments" .-> ORCH
    end

    subgraph SPEC["specialists (per workstream)"]
        CE[code-engineer]
        TE[test-engineer]
        DE[docs-engineer]
        NA[notebook-author]
    end

    subgraph CRIT["review panel (as relevant)"]
        AC[api-critic]
        VC[viz-critic]
        EC[editorial-critic]
    end

    ADV2["adversary<br/>(blind post-impl attack)"]
    QA["qa-engineer<br/>(auto-fixes lint / type / tests, up to 3x)"]

    GRILL == "accepted:<br/>'run it through'" ==> SPEC
    SPEC --> CRIT
    CRIT --> ADV2
    ADV2 --> QA
    QA -- "all workstreams clean" --> RL["research-liaison<br/>(wiki close-out)"]
    QA -- "BLOCKED" --> HALT([halt to maintainer])
    RL --> DONE([shipped])

    GRILL ~~~ CE
    GRILL ~~~ TE
    GRILL ~~~ DE
    GRILL ~~~ NA
    CE ~~~ AC
    TE ~~~ VC
    DE ~~~ EC

    QA == "clean:<br/>next workstream" ==> SPEC
    QA -. "must-fix:<br/>amend plan" .-> ORCH
    ORCH -. "re-dispatch fix<br/>(re-enters full review)" .-> SPEC
```

The full call-order detail — gates, checkpoints, finding-routing, and the research-run grounding rules — is diagrammed in [diagrams.md](diagrams.md).
