# Implementation Plan: Vote Acceptance (#17)

## Overview

When all players have voted, show the highest Fibonacci vote in an editable number input next to "Accept Estimate". Whatever value is in that field when the button is clicked becomes the story's estimate — no averaging.

## Changes

### `app/views/games/_stories_panel.haml`

Replace the `button_to "Accept Estimate"` with a small inline form:
- Number input pre-populated with `game.games_players.highest_voter.fibonacci_vote`
- "Accept Estimate" submit button
- Form POSTs to `accept_estimate_game_story_path` with `data: { turbo_stream: true }`

### `app/controllers/stories_controller.rb`

- `accept_estimate`: use `params[:estimate].to_d` instead of `compute_estimate`
- Remove the `compute_estimate` private method

## Files to Change

1. `app/views/games/_stories_panel.haml`
2. `app/controllers/stories_controller.rb`

## Tests

- Controller: `accept_estimate` stores the submitted estimate value
- Controller: `accept_estimate` with a user-overridden estimate stores the overridden value
