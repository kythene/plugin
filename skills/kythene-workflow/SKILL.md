---
name: kythene-workflow
description: How to work with Kythene - where a team and their AI review each other's work: recall context at session start, remember what you learn, publish your output for teammates and their AI to review and build on, and pick up feedback. Use whenever you are working in a project that has Kythene connected.
when_to_use: At the start of a working session on a Kythene-connected project, and whenever you produce output worth sharing, learn something worth keeping, or need to see what the team (and their AI instances) has produced.
---

# Working with Kythene

Kythene is where a team and their AI review each other's work - a shared, reviewed
memory of what the team has produced and agreed. Your work, and what you learn,
should flow into it so other people - and their AI instances - can see, review and
build on it. The Kythene MCP tools are how you do that.

## At the start of a session

1. **`catchup`** FIRST. It returns what changed in your workspaces since THIS
   instance last looked - publishes and shares by your other instances and your
   teammates, since your previous session - so you open already knowing "what did
   the other Claude do while I was away?" instead of finding out by chance. It
   excludes your own instance's writes, and reading it advances your cursor (so the
   next session shows only what is new again); pass `peek` to look without
   consuming. On the very first run it just sets your watermark and returns empty.
2. **`recall`** for the project you are about to work on. This returns the team's
   accumulated memories plus their artifact data in one call - decisions, gotchas,
   conventions, prior findings. Read it before doing anything, so you are not
   re-deriving what someone (or their instance) already worked out.
3. **`inbox`** to pick up feedback on your own previous publishes - comments,
   approvals, rejections since you last looked. Fold it into what you do next.
4. **`timeline`** (optionally) to see what has been published into the space
   recently, and **`presence`** to see who/what is active right now and whether
   anyone is touching the same area (conflict awareness).

## First session in a fresh workspace

If `recall` AND `timeline` both come back empty, this workspace is brand new -
give the human the payoff loop instead of a blank tool. Do it with THEIR real
work, never invented sample content:

1. Ask, briefly: "What are you working on right now?" One or two follow-ups at
   most (a key decision made, a gotcha hit).
2. `remember` 2-3 REAL things from their answers - the project one-liner, a
   decision, a gotcha - each with a short title and the project scope.
3. `publish` one small, real artifact they already have to hand (a README
   snippet, a config, a note) so the timeline isn't empty.
4. Then stage the payoff, verbatim: "Start a NEW session and ask me what I know
   about <project>. That's Kythene working." (Recall in the next session returns
   what you just deposited - that is the whole point.)

Keep it to a couple of minutes; the goal is one real deposit-and-recall cycle,
not a setup wizard.

## While you work

- **`remember`** anything durable you learn or decide - a fact, a convention, a
  resolved gotcha - with a short title and the project scope. Re-using a title in
  the same project supersedes the old memory, so keep it current rather than
  piling up duplicates. This is the point of Kythene: what you learn does not
  evaporate at the end of the session.
- **Keep memory true.** When a recalled memory contradicts the live system,
  fixing it is part of the task, not a separate chore. Verify against the real
  system first (a memory disagreeing with your assumption is not evidence it is
  wrong; disagreeing with the live system is), then `remember` the same title in
  the same project with the corrected content - this supersedes and keeps the
  history - or `deprecate` it with `replaced_by` when it is wholly superseded.
  Say in the body what changed and when. Most rot is one wrong line in an
  otherwise good note. Never leave a memory you know to be false in place, and
  never silently work around one.
- **`activity`** to report what you are working on (files, modules, topics) when
  you start on something, so teammates' instances see it and conflicts surface
  early.

## When you produce something worth sharing

- **`publish`** it (a bench result, a doc, a JSON output, a binary - any "piece of
  work") as a collection, with tags and a title. This makes it known to the space:
  people and their AI instances can find it, read it, comment and approve.
- Push a new **version** rather than re-publishing when you revise an artifact -
  that keeps history and clears stale approvals for re-review.
- **Deliver through Kythene by default.** A deliverable you produce - a report, a
  decision brief, a screenshot, a dataset, a document - belongs in Kythene, not
  handed over as a loose local file or a bare claude.ai Artifact. `publish` it and
  give the human its Kythene URL: the store is the canonical home, so the work is
  durable and the team (and their instances) can recall it.
  - Static deliverables (screenshots, PDFs, markdown reports): `publish` the file
    and hand back its `/c/<id>` URL.
  - An interactive **claude.ai Artifact**: `publish` its source (the HTML or
    markdown) as the durable copy, and put the live Artifact URL in that
    collection so the interactive render stays one click away - then hand back the
    Kythene URL, not the Artifact link on its own. If the Artifact is ever deleted
    or unshared, the durable copy still lives in Kythene.

## Always hand back a URL, never a bare ID

When you reference a Kythene item to a human, give the full, clickable URL - never
a bare id like `d14fa358-...`, which they cannot open. The tools already hand you
the link: `recall` returns each result's `ref`, and `catchup` / `inbox` return a
`url`. Surface that, resolved to an absolute URL.

- A collection or published artifact: `<KYTHENE_URL>/c/<id>` - e.g.
  `https://kythene.com/c/d14fa358-...`. This canonical link resolves through
  sign-in to the right workspace.
- A memory: the same `<KYTHENE_URL>/c/<id>` form - it is the memory's citable
  handle (what `recall` returns as `ref`).
- A specific **revision** has no URL of its own: link the collection's `/c/<id>`
  and name the revision number alongside it.

Always build the link from the configured `KYTHENE_URL`, not a hardcoded
`kythene.com`, so it resolves on a self-managed host too - a relative `ref` such
as `/c/<id>` just needs that host prefixed.

## Reviewing others' work

- **`comment`** and **`approve`** (or reject with a note) on a collection or
  artifact. Approvals pin to the current version and clear when a new version
  lands, so a green tick always means "the latest was reviewed".

## Reviewing at the block level

On a renderable artifact (markdown) whose collection has requested review, you can
flag and discuss individual **blocks** - a paragraph, heading, list item, code
block or table - not just the whole thing. This works in both directions: you can
triage a whole doc in one pass, and act on what others (human or AI) flagged.

- **Read the blocks.** `get_artifact` returns the doc's `blocks`, each with a
  stable `anchor`, its `text`, and its current `status`/`set_by`. Read them before
  reviewing.
- **Flag a block.** `review_block(artifact_id, anchor | quoted_text, status,
  comment?)` - one call per block. Address it by `anchor` (from get_artifact) or
  by quoting its text. `status` is one of, and means:
  - **needs_review** - look at this again (also auto-set when a flagged block
    changes on re-publish; you'll see `changed_since`);
  - **needs_work** - changes required;
  - **done** - the needed action is complete;
  - **approved** - signed off;
  - **reject_remove** - this block should be removed.
  A comment is allowed only once a status is set; set status empty to clear a flag.
- **Producing** (triage): read the blocks and set the right status per block, with
  a comment where you set one - so a human, or another instance, can act on it.
- **Acting**: pick up a `needs_work` block, do the work, then mark it `done`; treat
  `needs_review` (including the auto-set-on-change ones) as "look at this again".
- Human-set flags show in Ember, AI-set in Iris, so it is clear at a glance who
  judged what.

## From the terminal (the kythe CLI)

When MCP is not configured but you have the `kythe` CLI and an API key, drive the
same workflow from a shell. Reach for the CLI in scripted or non-interactive work
(a build step, a batch of publishes); prefer the MCP tools in normal in-session
work, since they return richer, in-context results.

Set it up once (a `twk_` API key from **Connect your AI** in the app):

```
export KYTHENE_URL=https://kythene.com   # your own host if self-hosting
export KYTHENE_TOKEN=twk_...                  # created in the app; shown once
```

Then the core loop maps one-to-one onto commands:

```
kythe catchup                                  # what changed since this instance last looked
kythe recall --project <p> [--search Q]       # read memory before you work
kythe remember <file|-> --title X --project <p>  # store what you learn (stdin with -)
kythe publish <file>... --title X --tag <t>    # publish a piece of work
kythe version <collection-id> <file>... --note X  # add a new version, keep history
kythe timeline [--tag T] [--search Q]          # what has been published
kythe get <collection-id>                      # a collection and its artifacts
kythe review <collection-id> --artifact <id> --block "text" --status needs_work --comment "..."  # flag a block
```

`recall` returns each memory with its full artifact content. Re-using a `--title`
in the same `--project` supersedes the old memory, exactly as over MCP. Add
`--space` (id or name from `kythe spaces`) only when you belong to more than one
workspace. Full reference: the CLI page in the app docs (`/docs/reference-cli`).

The CLI prints bare ids (e.g. `published <title> (<id>) rev N`); wrap one into
`$KYTHENE_URL/c/<id>` before you hand it to a human, per **Always hand back a
URL** above.

## The habit

Catch up and recall at the start, remember as you go, publish what you make, check
your inbox. Do that and the next instance - yours or a teammate's - starts from
where you finished instead of from scratch. That is the whole value of Kythene; use
it.
