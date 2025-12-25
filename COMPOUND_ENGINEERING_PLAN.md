# Compound Engineering Plan for SME Prototype Development

## Executive Summary

This plan transforms you from a minimally-trained Claude Code user into an effective orchestrator of AI agents, capable of building sophisticated, production-ready prototypes. The approach leverages your management experience—you'll direct AI agents the same way you'd direct a skilled team, with appropriate guardrails and quality gates.

**Core Philosophy**: Each unit of work makes the next unit easier. Every bug becomes a permanent lesson. Every code review updates the defaults. Every permission decision is understood before it's made.

---

## Part 1: Foundation Setup

### 1.1 Project Structure Template

Every SME prototype starts from the same foundation, ensuring Software Engineering can easily review and productionize:

```
project-root/
├── .claude/
│   ├── settings.json          # Permission rules, allowed/blocked commands
│   └── commands/              # Your custom slash commands
├── CLAUDE.md                  # Project-specific AI instructions
├── README.md                  # Handoff documentation
├── .env.example               # Required environment variables (no secrets)
├── .env.local                 # Local development secrets (gitignored)
├── app/
│   ├── api/                   # Server-side route handlers
│   └── (routes)/              # App router pages
├── lib/
│   ├── config.ts              # Centralized environment configuration
│   ├── types.ts               # Domain object TypeScript types
│   └── services/
│       ├── index.ts           # Service exports
│       ├── realService.ts     # Production implementations
│       └── mockService.ts     # Demo mode implementations
├── tests/
│   ├── unit/                  # Unit tests
│   └── integration/           # Integration tests
└── docs/
    └── decisions/             # Architecture decision records
```

### 1.2 Master CLAUDE.md Template

Create this as your starting template for every new project:

```markdown
# Project: [Project Name]

## SME Prototype Standards Compliance

This is an SME prototype. Follow these non-negotiable standards:

### Architecture Rules
- Use Next.js 14+ with App Router and TypeScript
- ALL external API calls (SharePoint, Graph, internal APIs) go through `/app/api/*` route handlers
- NEVER expose secrets or make privileged calls from browser code
- Every integration MUST have both `realService.ts` and `mockService.ts` implementations
- DEMO_MODE=true must work without any external dependencies

### File Organization
- Routes/pages: `/app`
- Server endpoints: `/app/api/*`
- Shared logic: `/lib`
- Integrations: `/lib/services`
- Configuration: `/lib/config.ts`
- Types: `/lib/types.ts`

### API Response Format
All API routes return consistent JSON:
```typescript
// Success
{ ok: true, data: T }
// Error
{ ok: false, error: { code: string, message: string } }
```

### Before Making Any Change
1. Ask: "Does this match an existing pattern in the codebase?"
2. Ask: "Could this introduce a security vulnerability?"
3. Ask: "Will this work in DEMO_MODE=true?"
4. Ask: "Is this the simplest solution that works?"

### Test Requirements
- Every new feature needs at least one test
- Write tests BEFORE implementation when possible
- Tests must pass in demo mode without external services

### Authentication Approach
- Stub `getCurrentUser()` and `authorize(role)` for now
- Do NOT hard-code user identities in business logic
- Structure code so Azure AD drops in cleanly later

### When Stuck
- Search the codebase for similar patterns first
- Check `/docs/decisions/` for prior architectural choices
- Ask me to clarify requirements before guessing
```

---

## Part 2: The Four-Phase Workflow

### Phase 1: PLAN (Where You Spend 80% of Your Time)

**Your Role**: Define what you want, review the AI's research and plan, make decisions.

**The AI's Role**: Research codebase, find patterns, study best practices, propose approaches.

#### Planning Command: `/compound-engineering:workflows:plan`

Use this command for any feature beyond a trivial fix. It will:
1. Research how similar problems are solved in your codebase
2. Check framework documentation for best practices
3. Analyze dependencies and integrations
4. Propose 2-3 implementation approaches with tradeoffs
5. Create acceptance criteria you can verify

#### Three Fidelity Levels

**Fidelity 1 - Quick Fixes** (1-10 minutes)
- Typos, copy changes, obvious bug fixes
- Simple styling adjustments
- Configuration changes
- Example prompt: "Fix the typo in the error message on line 42"

**Fidelity 2 - The Sweet Spot** (10 minutes - 2 hours)
- Features spanning multiple files
- New integrations following existing patterns
- Bug fixes requiring investigation
- Example prompt: "Add a new API endpoint for fetching user preferences, following our existing endpoint patterns"

**Fidelity 3 - Big Uncertain** (2+ hours, often days)
- Major new features where requirements are unclear
- Architectural changes
- New integration types not done before
- Approach: Build throwaway prototypes first to clarify requirements, then plan properly

#### The 8 Planning Strategies (Use These)

1. **Reproduce and Document** - For bugs, have AI reproduce without fixing first
2. **Ground in Best Practices** - Search web for how others solved similar problems
3. **Ground in Your Codebase** - Find existing patterns in your code
4. **Ground in Your Libraries** - Read source code of packages you use
5. **Study Git History** - Understand why past decisions were made
6. **Vibe Prototype** - Build quick throwaway versions to clarify requirements
7. **Synthesize with Options** - Combine research into 2-3 approaches with tradeoffs
8. **Review with Style Agents** - Run plan through specialized reviewers

### Phase 2: WORK (Execution)

**Your Role**: Monitor progress, answer clarification questions, spot-check results.

**The AI's Role**: Execute the plan systematically, run tests after each change, flag issues.

#### Execution Command: `/compound-engineering:workflows:work`

This command:
1. Creates an isolated git branch and worktree
2. Breaks the plan into trackable todos
3. Executes tasks systematically
4. Runs tests after every change
5. Creates a pull request when complete

#### Parallel Work Pattern

You can run multiple Claude Code instances simultaneously on different features:
- Each works in its own git worktree (isolated copy of the code)
- They don't interfere with each other
- You orchestrate like a manager checking in on multiple team members

### Phase 3: REVIEW (Quality Assurance)

**Your Role**: Approve findings, decide what to fix vs. defer.

**The AI's Role**: Check code from multiple perspectives, identify issues, explain severity.

#### Review Command: `/compound-engineering:workflows:review`

This runs 12+ specialized review agents in parallel:
- **Security Sentinel** - Vulnerability scanning
- **Performance Oracle** - Optimization opportunities
- **Architecture Strategist** - Design review
- **Data Integrity Guardian** - Database concerns
- **Code Simplicity Reviewer** - Complexity checks
- **Language-specific reviewers** - TypeScript best practices

Each finding is triaged for you to approve or dismiss.

### Phase 4: COMPOUND (Learning Loop)

**Your Role**: Decide what lessons to capture.

**The AI's Role**: Document learnings, update CLAUDE.md, create tests for future prevention.

This is where the magic happens. After every significant piece of work:

1. **Capture patterns**: "Add this to CLAUDE.md so we don't repeat this mistake"
2. **Create tests**: If a bug could recur, write a test to catch it
3. **Update agents**: If a review caught something important, strengthen the reviewer
4. **Document decisions**: Record architectural choices in `/docs/decisions/`

---

## Part 3: Permission Decisions Guide

### Your Custom Permission Hook

Before every permission decision, Claude will provide a structured explanation. This is implemented via a pre-command hook that runs before any permission-requiring action:

#### Permission Explanation Format

```
📋 PERMISSION REQUEST
━━━━━━━━━━━━━━━━━━━━━

ACTION: [What Claude wants to do]
SCOPE: [Specific files/commands affected]

🎯 PURPOSE
[Why this action is needed for your current task]

⚠️ IMPLICATIONS
• Immediate: [What happens right now]
• Persistent: [If you choose "always allow" - what that means]
• Risk Level: [Low/Medium/High with explanation]

💡 RECOMMENDATION
[Accept/Decline with reasoning]

Options:
1. Allow once - Safe choice for unfamiliar actions
2. Allow for session - Good for repeated trusted actions
3. Always allow - Only for well-understood, low-risk patterns
4. Deny - If unsure or seems risky
```

### Pre-Configured Permission Rules

In `.claude/settings.json`, configure safe defaults:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "npm run build",
      "npm run test",
      "npm run lint",
      "git status",
      "git diff",
      "git log"
    ],
    "deny": [
      "rm -rf",
      "DROP TABLE",
      "DELETE FROM",
      "curl * | bash",
      ".env",
      "credentials",
      "secrets"
    ],
    "ask": [
      "Write",
      "Edit",
      "git commit",
      "git push",
      "npm install"
    ]
  }
}
```

---

## Part 4: Test-Driven Development for Non-Developers

### The TDD Pattern for SME Prototypes

TDD isn't just for developers—it's your quality assurance. Here's how to use it:

#### Step 1: Define What "Done" Looks Like

Before building anything, write down acceptance criteria:
```
Feature: User can submit a support ticket
- User sees a form with subject and description fields
- Clicking submit sends data to the API
- Success message appears on successful submission
- Error message appears if submission fails
- Form works in demo mode without hitting real API
```

#### Step 2: Ask Claude to Write Tests First

Prompt: "Write tests for these acceptance criteria before implementing the feature. The tests should fail until we implement the feature correctly."

#### Step 3: Implement Until Tests Pass

Prompt: "Now implement the feature. Run tests after each change. Keep going until all tests pass."

#### Step 4: Review and Refine

The tests become documentation. Software Engineering can:
- See exactly what the feature is supposed to do
- Verify the feature works as intended
- Understand edge cases you considered

### Test Organization

```
tests/
├── unit/
│   ├── services/
│   │   └── ticketService.test.ts
│   └── utils/
│       └── validation.test.ts
└── integration/
    └── api/
        └── tickets.test.ts
```

---

## Part 5: Your Custom Slash Command

### `/sme-prototype` - Your Primary Workflow Command

This command encapsulates everything you need. Create it at:
`.claude/commands/sme-prototype.md`

```markdown
---
description: SME Prototype workflow - guided development with standards compliance
---

You are helping an experienced manager (not a software developer) build production-ready prototypes. This person orchestrates AI agents like they would orchestrate a skilled team.

## Initial Assessment

First, determine what phase we're in:

1. **New Project Setup**
   - Create project structure from template
   - Initialize CLAUDE.md with SME standards
   - Set up demo mode infrastructure

2. **Feature Development**
   - Use Plan → Work → Review → Compound workflow

3. **Bug Investigation**
   - Reproduce first, then diagnose, then fix

4. **Production Handoff**
   - Generate handoff documentation
   - Run full review suite
   - Verify demo mode works

## Standards Checklist (Verify Before Every Commit)

□ All external API calls are server-side only
□ Demo mode works without external dependencies
□ Integration has both real and mock implementations
□ API responses use consistent {ok, data/error} format
□ Types are defined in /lib/types.ts
□ Configuration comes from /lib/config.ts
□ Tests cover new functionality
□ No secrets in browser-accessible code

## Permission Decision Support

Before any permission-requiring action, explain:
1. What action and why
2. Risk level (Low/Medium/High)
3. What "always allow" would mean
4. Your recommendation

## Learning Loop

After completing any significant work:
1. Ask: "What should we remember from this for next time?"
2. Update CLAUDE.md if there's a reusable pattern
3. Create a test if we found a bug
4. Document decision if it was architectural

## When Unsure

- Default to asking clarifying questions
- Default to simpler solutions
- Default to matching existing patterns
- Never guess at security implications
```

---

## Part 6: Specialized Sub-Agents

### 6.1 Security Gate Agent

Create `.claude/agents/security-gate.md`:

```markdown
---
name: security-gate
description: Reviews code changes for security vulnerabilities before they're committed
---

You are a security specialist reviewing SME prototype code. Focus on:

1. **No secrets in browser code**
   - Check that API keys, tokens, credentials are server-side only
   - Verify .env files are gitignored

2. **Input validation**
   - All user input is validated before use
   - No direct SQL/NoSQL query construction from user input

3. **API security**
   - Route handlers validate request origin/auth as appropriate
   - Sensitive operations require authorization checks

4. **Demo mode safety**
   - Mock services don't bypass security patterns
   - Demo data doesn't include real credentials

Output a security report:
- 🟢 PASS: No issues found
- 🟡 ADVISORY: Minor concerns (list them)
- 🔴 BLOCK: Must fix before commit (list them)
```

### 6.2 Production Readiness Agent

Create `.claude/agents/production-ready.md`:

```markdown
---
name: production-ready
description: Assesses prototype readiness for Software Engineering handoff
---

You assess whether an SME prototype meets handoff standards.

## Checklist

### Architecture (/5)
- [ ] Uses Next.js 14+ App Router
- [ ] TypeScript throughout
- [ ] Correct folder structure
- [ ] Clean separation of concerns
- [ ] Environment-driven configuration

### Integration Pattern (/5)
- [ ] All integrations in /lib/services
- [ ] Swappable real/mock implementations
- [ ] Demo mode fully functional
- [ ] Consistent API response format
- [ ] Proper error handling

### Security (/5)
- [ ] No secrets in browser
- [ ] Server-side only for privileged ops
- [ ] Auth hooks in place (even if stubbed)
- [ ] No hardcoded credentials
- [ ] Input validation present

### Documentation (/5)
- [ ] README with run instructions
- [ ] CLAUDE.md for AI context
- [ ] Key decisions documented
- [ ] API endpoints documented
- [ ] Swap points identified

### Testing (/5)
- [ ] Core features have tests
- [ ] Tests pass in demo mode
- [ ] Tests document expected behavior
- [ ] No flaky tests
- [ ] Clear test organization

## Score and Recommendation

Calculate total score and recommend:
- 20-25: Ready for production review
- 15-19: Minor cleanup needed
- 10-14: Significant gaps - list remediation
- <10: Not ready - major rework needed
```

---

## Part 7: Daily Workflow Patterns

### Morning Routine

1. **Check overnight work** (if you had agents running)
   ```
   /tasks
   ```

2. **Review pending PRs**
   ```
   /compound-engineering:workflows:review
   ```

3. **Pick up new work**
   ```
   /compound-engineering:workflows:plan "Feature description..."
   ```

### During Development

1. **For quick fixes** (Fidelity 1):
   - Just describe what you want directly
   - Review the change
   - Commit if good

2. **For features** (Fidelity 2-3):
   - Start with `/compound-engineering:workflows:plan`
   - Review and approve the plan
   - Execute with `/compound-engineering:workflows:work`
   - Review with `/compound-engineering:workflows:review`
   - Capture learnings

### Before Ending

1. **Commit work in progress**
   ```
   git status
   ```

2. **Update learnings**
   - Add any new patterns to CLAUDE.md
   - Document decisions made

3. **Note blockers or questions**
   - Create GitHub issues for tomorrow

---

## Part 8: Handoff Documentation Template

When ready to hand off to Software Engineering, generate this document:

### README.md Template

```markdown
# [Project Name]

## Overview
[One paragraph describing what the app does and its primary use case]

## Quick Start (Demo Mode)

```bash
# Install dependencies
npm install

# Run in demo mode (no external services needed)
DEMO_MODE=true npm run dev
```

Visit http://localhost:3000

## Architecture

### Tech Stack
- Next.js 14 with App Router
- TypeScript
- [List other key technologies]

### Key Files
- `/app/api/*` - All server-side API routes
- `/lib/services/` - Integration implementations
- `/lib/config.ts` - Environment configuration
- `/lib/types.ts` - TypeScript type definitions

## Integrations

### [Integration Name, e.g., SharePoint]
- **Real implementation**: `/lib/services/sharepointService.ts`
- **Mock implementation**: `/lib/services/mockSharepointService.ts`
- **Required environment variables**:
  - `SHAREPOINT_SITE_URL`
  - `SHAREPOINT_LIST_ID`

## For Software Engineering

### What Can Be Shipped As-Is
[List features that are production-ready]

### What Needs Hardening
[List areas needing security/performance work]

### Known Limitations
[List things that don't work yet or have workarounds]

### Swap Points
[List where real implementations need to replace mocks]

## Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch
```

## Decision Log
See `/docs/decisions/` for architectural decisions and their rationale.
```

---

## Part 9: Troubleshooting Guide

### When Claude Goes Off Track

**Symptoms**: Claude is doing unexpected things, changing too much code, or going in circles.

**Fix**:
1. Press `Escape` to stop
2. Press `Escape` again to revert to last checkpoint
3. Be more specific in your next prompt
4. Consider using plan mode first

### When Tests Keep Failing

**Symptoms**: Tests fail, Claude "fixes" them by changing the test assertions.

**Fix**:
1. Add to CLAUDE.md: "Never modify test assertions to make tests pass"
2. Prompt: "The test expectation is correct. Fix the implementation, not the test."

### When Permission Prompts Are Overwhelming

**Fix**: Update `.claude/settings.json` to pre-allow common safe operations.

### When Code Seems Too Complex

**Symptoms**: Solutions have many files, lots of abstraction, over-engineering.

**Fix**:
1. Add to CLAUDE.md: "Prefer simple, direct solutions. Avoid premature abstraction."
2. Prompt: "Simplify this. What's the minimum code needed?"

### When You Don't Understand What Happened

**Fix**:
```
Explain what you just did in non-technical terms.
What was the problem?
What did you change?
How can I verify it works?
```

---

## Part 10: Growth Path

### Week 1-2: Foundation
- Set up your project template
- Install Compound Engineering plugin
- Build one simple prototype using the workflow
- Focus on Plan → Work → Review → Compound cycle

### Week 3-4: Confidence Building
- Build a more complex prototype with real integrations
- Practice parallel agent work (multiple features at once)
- Start customizing CLAUDE.md based on your learnings

### Month 2: Refinement
- Create your own specialized sub-agents for common patterns
- Build slash commands for repeated workflows
- Train other SMEs using your documented patterns

### Month 3+: Scaling
- Establish SME prototype standards across departments
- Create reusable component library
- Build feedback loops with Software Engineering

---

## Appendix A: Quick Reference Commands

| Command | When to Use |
|---------|-------------|
| `/compound-engineering:workflows:plan` | Starting any new feature |
| `/compound-engineering:workflows:work` | Executing an approved plan |
| `/compound-engineering:workflows:review` | Before merging any code |
| `/sme-prototype` | Your custom guided workflow |
| `Escape` | Stop current operation |
| `Escape Escape` | Revert to last checkpoint |
| `/tasks` | Check background work |

## Appendix B: Files to Create

1. **Project template** (use for every new prototype)
2. **CLAUDE.md template** (customize per project)
3. **`.claude/settings.json`** (permission rules)
4. **`.claude/commands/sme-prototype.md`** (your main command)
5. **`.claude/agents/security-gate.md`** (security reviewer)
6. **`.claude/agents/production-ready.md`** (handoff assessor)

## Appendix C: Key Principles

1. **Plan before you build** - 80% of time in planning = better results
2. **Match existing patterns** - Don't invent when you can reuse
3. **Understand before allowing** - Every permission decision is informed
4. **Capture learnings** - Every problem solved once prevents it forever
5. **Demo mode always works** - Proof the logic is correct without dependencies
6. **Simple beats clever** - Software Engineering can add complexity later

---

*This plan compounds. Every project you build using this system makes the next one easier.*
