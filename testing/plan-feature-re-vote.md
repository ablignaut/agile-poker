# Implementation Plan: Re-vote / Discussion Round (#18)

## Overview

When all players have voted, show a "Re-vote" button on the current story card alongside the Accept Estimate form. Clicking it calls the existing `clear_votes` action, resetting all votes and hiding the Accept Estimate form until players vote again.

## Changes

### `app/views/games/_stories_panel.haml`

Inside the `players_all_voted?` block, add a `button_to "Re-vote"` that POSTs to `clear_votes_game_path(game)` with `data: { turbo_stream: true }`.

No new controller action, route, or model change needed.

## Files to Change

1. `app/views/games/_stories_panel.haml` only

## Tests

- The existing `clear_votes` controller behaviour is already tested
- Add a view-level assertion: when `players_all_voted?`, the stories panel includes the Re-vote path
- This is a view change so manual verification is the primary test
