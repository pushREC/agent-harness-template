---
created: 2025-12-28
tags:
  - type/documentation
  - topic/agents
  - topic/schema
---

# Feature List Schema

The schema for `feature_list.json` - the source of truth for all features.

## Schema

```json
[
  {
    "category": "functional | style | integration | edge-case",
    "description": "Brief description of what this feature does",
    "steps": [
      "Step 1: Action to perform",
      "Step 2: Expected behavior",
      "Step 3: Verification"
    ],
    "passes": false
  }
]
```

## Fields

### category

| Value | Description |
|-------|-------------|
| `functional` | Core functionality - buttons, forms, CRUD |
| `style` | Visual appearance - colors, layout, responsive |
| `integration` | Multi-component flows - login + redirect |
| `edge-case` | Error handling, empty states, boundaries |

### description

Brief, clear description of what the feature does and what this test verifies.

**Good:**
- "User can create a new task with title and due date"
- "Task cards display priority badges correctly"
- "Empty state shown when no tasks exist"

**Bad:**
- "Test task creation" (too vague)
- "It works" (not descriptive)

### steps

Array of testing steps. Should be:
- Actionable (clear what to do)
- Verifiable (clear what to check)
- Complete (covers the whole feature)

**Mix of sizes:**
- Simple tests: 2-5 steps
- Comprehensive tests: 10+ steps

### passes

Boolean indicating if the feature has been verified.

**Rules:**
- Starts as `false`
- Changes to `true` ONLY after testing
- Never goes back to `false` (if regression, create new bug-fix feature)

## Example

```json
[
  {
    "category": "functional",
    "description": "User can create a new task with title, description, due date, and priority",
    "steps": [
      "Navigate to http://localhost:3000",
      "Click 'New Task' button",
      "Verify modal appears with form",
      "Enter 'Test Task' in title field",
      "Enter 'Test description' in description field",
      "Select tomorrow's date for due date",
      "Select 'High' priority",
      "Click 'Save' button",
      "Verify modal closes",
      "Verify task appears in list",
      "Verify task shows title 'Test Task'",
      "Verify task shows 'High' priority badge"
    ],
    "passes": false
  },
  {
    "category": "style",
    "description": "High priority tasks display red priority badge",
    "steps": [
      "Create a task with High priority",
      "Take screenshot of task list",
      "Verify badge is red color (#EF4444)",
      "Verify badge text is readable"
    ],
    "passes": false
  },
  {
    "category": "edge-case",
    "description": "Empty title shows validation error",
    "steps": [
      "Click 'New Task' button",
      "Leave title empty",
      "Click 'Save'",
      "Verify error message appears",
      "Verify task is not created"
    ],
    "passes": false
  }
]
```

## Guidelines

### Feature Count

| Project Size | Target Features |
|--------------|-----------------|
| Simple | 30-50 |
| Medium | 50-100 |
| Complex | 100-200+ |

### Coverage

Ensure features cover:
- All CRUD operations
- All UI states (empty, loading, error, success)
- All responsive breakpoints
- All user flows
- Edge cases and error handling

### Immutability

**NEVER modify existing features except `passes` field.**

Why:
- Prevents accidentally dropping requirements
- Creates clear audit trail
- Enables accurate progress tracking

If a feature needs to change, create a new feature instead.

## Related

- [[TWO-AGENT-PATTERN]]
- [[SESSION-MANAGEMENT]]
