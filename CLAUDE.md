# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Backlog

**"work the backlog"** — Read `backlog-instructions.md`. Find the next open GitHub Issue at https://github.com/ablignaut/agile-poker/issues following the priority and status label rules defined in that file. Execute it end-to-end: Planning → Implementation → Code Review → Testing → Done.

---

## Overview

Agile Poker is a Rails application for collaborative story point estimation. Teams join a session, vote on story complexity across three dimensions (amount of work, complexity, unknowns/risks), and see a combined summary once all votes are cast.

## Tech Stack

- Ruby on Rails
- ActionCable (WebSockets for real-time voting)
- Hotwire Turbo Streams
- Bootstrap
- esbuild (via jsbundling-rails)
- SQLite (development)

## Development

```bash
rails db:create db:migrate
rails s
```

## Running Tests

```bash
rails test
```

## Branch Conventions

- Base branch: `master`
- Feature branches: `feature/{slug}` (created as git worktrees per `backlog-instructions.md`)
