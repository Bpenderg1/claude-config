# Claude SME Prototype Config

Shared Claude Code configuration for building production-ready SME prototypes. This config provides guardrails, guided workflows, and quality gates for non-developers building apps that will be handed off to Software Engineering.

## Quick Install

```bash
git clone [your-repo-url] ~/claude-config
cd ~/claude-config
chmod +x install.sh
./install.sh
```

## What's Included

### Commands (available in all projects after install)

| Command | Purpose |
|---------|---------|
| `/sme-prototype` | Guided workflow with permission explanations and standards enforcement |

### Agents

| Agent | Purpose |
|-------|---------|
| `security-gate` | Reviews code for SME-specific security issues before commit |
| `production-ready` | Scores prototype readiness for SWE handoff (target: 20+/25) |

### Hooks

| Hook | Purpose |
|------|---------|
| `permission-explainer` | Provides structured explanations before every permission decision |

### Templates

| Template | Purpose |
|----------|---------|
| `CLAUDE.md.template` | Starting point for project-specific AI instructions |
| `NEW_PROJECT_SETUP.md` | Step-by-step guide for creating new projects |

## Documentation

- **COMPOUND_ENGINEERING_PLAN.md** - Complete reference guide for the workflow
- **INTEGRATION_AND_WORKFLOW_GUIDE.md** - How this integrates with the Compound Engineering plugin, testing effectiveness, and step-by-step workflow

## SME Prototype Standards

All prototypes built with this config follow these standards:

1. **Next.js 14+ with App Router and TypeScript**
2. **No secrets in browser code** - All external calls server-side
3. **Swappable integrations** - Real and mock implementations
4. **Demo mode required** - Works without external dependencies
5. **Consistent API responses** - `{ok: true, data}` or `{ok: false, error}`
6. **Typed domain models** - All types in `/lib/types.ts`
7. **Environment-driven config** - All settings via env vars

## Workflow Summary

```
1. PLAN   → /compound-engineering:workflows:plan
2. WORK   → /compound-engineering:workflows:work
3. REVIEW → /compound-engineering:workflows:review + custom agents
4. COMPOUND → Capture lessons in CLAUDE.md
5. HANDOFF → Generate docs, verify demo mode, create PR
```

## Requirements

- Claude Code CLI installed
- Compound Engineering plugin installed (`claude plugins install compound-engineering`)

## For New Team Members

1. Clone this repo
2. Run `./install.sh`
3. Read `COMPOUND_ENGINEERING_PLAN.md` for the full workflow
4. Start your first project with `NEW_PROJECT_SETUP.md`

## Contributing

When you discover patterns that should apply to all SME prototypes:
1. Update the relevant file in this repo
2. Run `./install.sh` to apply locally
3. Push changes so others benefit
