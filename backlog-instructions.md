# Backlog Instructions

## Overview

GitHub Issues at https://github.com/ablignaut/agile-poker/issues are the backlog. Claude reads issues to find work and uses the `gh` CLI to update issue labels as work progresses through each stage.

Claude never creates or edits issues — that is the user's job. Claude only updates labels.

---

## Label System

### Status Labels

Claude transitions these as work progresses. The issue lifecycle maps to:

| Label | Meaning |
|---|---|
| *(no status label)* | Ready to be worked — treated the same as `status: open` |
| `status: open` | Explicitly marked as ready |
| `status: planning` | Claude is writing the implementation plan |
| `status: in-progress` | Active development underway |
| `status: in-review` | PR is open, waiting for review/merge |
| `status: hold` | Skip — not ready |
| `status: product-review` | Skip — awaiting product owner approval before implementation |

**Product owner approval:** When a PO approves an issue, they change its label from `status: product-review` to `status: open`. Claude will then pick it up on the next "work the backlog" run.

Issues close automatically when their PR is merged (via `Closes #N` in the PR body). No manual closure needed.

### Priority Labels

Set by the user. Claude uses these to determine pickup order.

| Label | Priority |
|---|---|
| `priority: high` | Picked up first |
| `priority: medium` | Picked up second |
| `priority: low` | Picked up third |
| *(no priority label)* | Picked up last |

---

## Finding the Next Issue

1. Fetch all open issues:
   ```bash
   gh issue list --repo ablignaut/agile-poker --state open --json number,title,labels,body --limit 50
   ```

2. Exclude any issue carrying one of these labels: `status: hold`, `status: product-review`, `status: planning`, `status: in-progress`, `status: in-review`.

3. From the remaining issues, pick using this order:
   - First: issues with `priority: high`
   - Then: issues with `priority: medium`
   - Then: issues with `priority: low`
   - Finally: issues with no priority label
   - Within each priority group, take the **lowest issue number first**

4. The selected issue is the next story. Use its number as `{issue-number}` throughout. Derive `{short-name}` from the issue title: lowercase, spaces to hyphens, prefixed with `feature/`. Example: issue "Add dark mode" → `feature/add-dark-mode`.

---

## Workflow

### Planning

1. Mark the issue as planning:
   ```bash
   gh issue edit {issue-number} --repo ablignaut/agile-poker \
     --add-label "status: planning" \
     --remove-label "status: open"
   ```
   *(If the issue had no status label, omit `--remove-label`.)*

2. Read the issue body carefully. Do not write any code yet.

3. Create the `testing/` directory if it does not exist:
   ```bash
   mkdir -p testing
   ```

4. Write an implementation plan to `testing/plan-{short-name}.md`. Use the issue title and body as the full requirements.

5. Create a new git worktree and branch from `master`:
   ```bash
   git fetch origin
   git worktree add {short-name} -b {short-name} origin/master
   ```
   Example:
   ```bash
   git fetch origin
   git worktree add feature/add-dark-mode -b feature/add-dark-mode origin/master
   ```

6. Immediately continue to Implementation without waiting for approval.

> Always ensure the relevant git worktree and branch is checked out before doing any work.

---

### Implementation

1. Mark the issue as in progress:
   ```bash
   gh issue edit {issue-number} --repo ablignaut/agile-poker \
     --add-label "status: in-progress" \
     --remove-label "status: planning"
   ```

2. Read the plan from `testing/plan-{short-name}.md`.

3. Check out the relevant git worktree at `{short-name}`.

4. Write the code to implement the story.

5. Commit the code.

6. Immediately continue to Code Review.

---

### Code Review

1. Review the changes in the git worktree compared to `master`.
2. If the review **fails**, return to Implementation and iterate.
3. If the review **passes**, continue to Testing.

---

### Testing

1. Check out the relevant git worktree at `{short-name}`.
2. Write a test plan to `testing/test-plan-{short-name}.log`.
3. Run all tests required to validate the story.
4. Write full testing details to `testing/testing-{short-name}.log` and update `test-plan-{short-name}.log` with pass/fail results.
5. Commit both log files to the git worktree.
6. If testing **fails**, return to Implementation.
7. If testing **passes**, continue to Done.

---

### Done

1. Mark the issue as in review:
   ```bash
   gh issue edit {issue-number} --repo ablignaut/agile-poker \
     --add-label "status: in-review" \
     --remove-label "status: in-progress"
   ```

2. Push the branch and open a PR. Always include `Closes #{issue-number}` in the PR body so the issue closes automatically when the PR is merged:
   ```bash
   gh pr create --title "{title}" --body "$(cat <<'EOF'
   ## Summary
   {bullet points describing what was done}

   ## Test plan
   {checklist of what was tested}

   Closes #{issue-number}

   🤖 Generated with [Claude Code](https://claude.com/claude-code)
   EOF
   )"
   ```

3. The issue will close automatically on merge. The `status: in-review` label remains until then.

4. Return to **Finding the Next Issue** and immediately pick up the next story from the backlog.
