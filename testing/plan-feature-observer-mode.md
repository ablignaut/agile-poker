# Implementation Plan: Observer Mode (#19)

## Overview

Add an observer role to game sessions. Observers join via the same join form but choose "Join as Observer". They see all real-time updates but have no vote UI and are excluded from all voting logic.

## Schema Change

Add an `observer` boolean column (default `false`) to `games_players`:

```ruby
add_column :games_players, :observer, :boolean, null: false, default: false
```

## Model Changes (`app/models/games_player.rb`)

- Update `players_not_voted` and `players_voted` scopes to exclude observers (`where(observer: false)`)
- Update `players_all_voted?` and `players_not_voted?` to only count non-observers
- Add `observer?` instance method for convenience

## Controller Changes

### `GamesController#join`

- Permit `observer` param from the join form
- Set `observer: true/false` when finding/creating the `games_player` record

### `GamesController#player_vote`

- Guard: if `@games_player.observer?`, do nothing (observers cannot vote)

## View Changes

### `_form_join.haml`

- Add two submit buttons or a checkbox: "Join as Voter" (default) and "Join as Observer"
- Pass `observer: true/false` as a hidden field or via separate buttons

### `games/show.html.haml`

- If `@games_player.observer?`, render a read-only observer notice instead of `_form_vote`

### `_players_table.haml`

- Split display: voters in the main table, observers in a small "Observers" section below with just their name and an "Observer" badge
- Observers do not appear in voting columns or aggregates

## Files to Change

1. `db/migrate/*_add_observer_to_games_players.rb` (new)
2. `app/models/games_player.rb`
3. `app/controllers/games_controller.rb`
4. `app/views/games/_form_join.haml`
5. `app/views/games/show.html.haml`
6. `app/views/games/_players_table.haml`
7. `app/views/games/_form_vote.haml` (minor — not shown to observers)

## Tests

- **Model:** scopes exclude observers; `players_all_voted?` ignores observers
- **Controller:** join with `observer: true` stores the flag; observer cannot vote
- **Fixture:** add an observer fixture to `games_players.yml`

## Manual Verification Required

- Real-time: observer joining triggers a broadcast and appears in the players table for all connected clients
- Observer sees live vote reveals and story changes but has no vote form
