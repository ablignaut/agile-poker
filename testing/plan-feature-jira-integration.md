# Plan — Jira Integration (Issue #27)

## Goal
Pull Jira ticket details into the planning session and write the vote outcome back to Jira as a comment.

## Scope (from issue)
1. **Activate a story** → call Jira API, fetch the ticket's `summary` and presence flags for three custom fields (Acceptance Criteria, Technical Review, QA Notes). Display the summary alongside the issue key plus a tick (✓) or cross (✗) for each field.
2. **When all players have voted** (and the "Accept Estimate" button appears) → refresh the same Jira details so the ticks/crosses reflect any updates made during planning.
3. **When Accept Estimate is clicked** → post a comment on the Jira ticket containing the player votes table and the highest/lowest summary.
4. **Config** → add `JIRA_API_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN` placeholders to `.env.example`.

## Approach (no DB persistence)

The `stories` table stays as-is — only `issue_key` is persisted. Jira details are fetched on demand and held in `Rails.cache` so multiple renders within a session don't hammer the API. The two moments the issue calls for ("on activate" and "when everyone has voted") explicitly invalidate the cache so the next render returns fresh data.

### Config
- `.env.example` gains `JIRA_API_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN`. Falls back to existing `JIRA_URL` if `JIRA_API_URL` is unset.
- Feature is **fully optional**: `JiraClient.configured?` returns true only when email + token + a URL are all present. If false, the integration silently no-ops and the UI looks unchanged from before.

### Service — `app/lib/jira_client.rb`
Stdlib `Net::HTTP`, no new gem dependency.

```
JiraClient.configured?
JiraClient.issue(issue_key)            # cached via Rails.cache
JiraClient.refresh_issue(issue_key)    # invalidates cache, returns fresh
JiraClient.add_comment(issue_key, body)
```

- `issue` / `refresh_issue` return a `Result` struct: `summary`, `acceptance_criteria_present`, `technical_review_present`, `qa_notes_present`, `found?`. A failed lookup or 404 returns a `found? == false` result without raising.
- Cache key: `jira:issue:#{issue_key}`. No expiry — we control invalidation explicitly. Activate and all-voted call `refresh_issue`.
- Custom field detection: GET `/rest/api/3/issue/{key}?expand=names&fields=*all`. Match field names case-insensitively against the three expected names ("Acceptance Criteria", "Technical Review", "QA Notes"). Field is "present" when its value is non-blank.
- Comments: POST `/rest/api/2/issue/{key}/comment` with wiki markup body (v2 supports wiki markup natively — much simpler than ADF tables).
- All errors caught and logged via `Rails.logger.warn`.

### Renderer — `app/lib/jira_comment_renderer.rb`
Pure function that takes a game and returns the wiki-markup comment body:
- A `||Player||Complexity||Amount of Work||Unknowns/Risks||Total||Fibonacci||` table from `game.games_players.voters`.
- A `||Metric||Player||Total||Fibonacci||` table with Highest / Lowest rows.

### Controller wiring
- `StoriesController#activate` → after activating, call `JiraClient.refresh_issue(@story.issue_key)` (best-effort, swallowed if not configured).
- `GamesController#player_vote` → after vote save, if the active story exists AND all players have now voted AND the previous state was "not all voted" (transition detection), call `JiraClient.refresh_issue(active_story.issue_key)`.
- `StoriesController#accept_estimate` → BEFORE the call to `update!(status: 'estimated', ...)` clears the votes, render the comment body from the still-current game state and call `JiraClient.add_comment`.

### View — `_stories_panel.haml`
"Current Story" card body:
- Issue key link (existing).
- If `JiraClient.configured?`, call `JiraClient.issue(active_story.issue_key)` and:
  - Render `result.summary` under the issue key if present.
  - Render three small indicators (badges or inline ✓/✗) for the three fields.

### Error handling
- `JiraClient` swallows errors and logs them. Controllers do not need their own rescues.
- Comment posting failure must not roll back the estimate or break the Turbo response.

## Files

**New**
- `app/lib/jira_client.rb`
- `app/lib/jira_comment_renderer.rb`
- `test/lib/jira_client_test.rb`
- `test/lib/jira_comment_renderer_test.rb`

**Modified**
- `.env.example`
- `app/controllers/stories_controller.rb`
- `app/controllers/games_controller.rb` (player_vote)
- `app/views/games/_stories_panel.haml`

**No migration. No model changes.**

## Testing strategy
- Inject a thin internal `http_get` / `http_post` boundary on `JiraClient` so tests can stub responses with `Minitest::Mock` without adding WebMock.
- Renderer is a pure function over a fake game-like object.
- Controllers: stub the client and assert it's called on activate/accept and on the all-voted transition.
- **Manual browser verification** needed for: ticks/crosses appear, summary renders, comment posts on accept — only verifiable against a real Jira instance, so flag for the user.

## Risks
- Adds a synchronous HTTP call to the activate + last-vote requests. Acceptable for an internal team tool; if it gets slow, push into a background job.
- Custom field names: matched by human-readable name. Renamed fields would not be detected. Future enhancement could expose this via env vars; out of scope for this issue.
