# Kythene plugin

Connects your AI coding agent to [Kythene](https://www.kythene.com), the shared
memory and output layer for AI-native teams. Your work and what you learn flow
into Kythene, so your teammates and their AI instances can see it and build on
it, rather than each session starting cold.

The plugin ships two things:

- **an MCP server** at `https://kythene.com/mcp/kythene`, giving your agent the Kythene tools
  (`catchup`, `recall`, `remember`, `publish`, and the rest), and
- **the `kythene-workflow` skill**, which teaches the agent when to reach for
  them: catch up at the start of a session, recall before starting work, and
  publish what it produces.

It targets [Agent Plugins 1.0](https://agent-plugins.org/), so it also carries a
Claude Code manifest in `.claude-plugin/`.

## Installing

In Claude Code, add this marketplace and install the plugin:

    /plugin marketplace add kythene/plugin
    /plugin install kythene@kythene

Other clients: install from your client's plugin directory or marketplace,
pointing at this repository.

The MCP server is authenticated: the first time your agent uses it, you will be
asked to authorise access to your Kythene workspace. You need a Kythene account -
sign up at [kythene.com](https://kythene.com).

## Running your own Kythene?

**This repository points at the hosted service at `https://kythene.com/mcp/kythene`.** It is baked in,
because a Git repository is a static artifact and cannot know about your install -
so do not install from this repository on a self-host box, or your agent will talk
to our Kythene rather than yours.

Install from your own instance instead. Every instance advertises a marketplace
carrying its own URL, so the install is one command and the plugin talks to your
box:

    /plugin marketplace add https://<your-instance>/.claude-plugin/marketplace.json
    /plugin install kythene@kythene

(There is a copy-paste version on your instance's "Connect your AI" page.) That
`archive` source needs Claude Code v2.1.224 or newer; on an older version,
download `/kythene-plugin.zip` from your instance and run `/plugin marketplace add
./kythene` from the unzipped folder.

## A note on this repository

The contents are **generated** from the Kythene application, which is where the
skill and the manifests are maintained. That keeps this repository and the
per-instance bundle from drifting apart. Pull requests that edit these files
directly would be overwritten by the next publish, so please raise an issue
instead and we will make the change at source.

## Licence

MIT. See [LICENSE](LICENSE).
