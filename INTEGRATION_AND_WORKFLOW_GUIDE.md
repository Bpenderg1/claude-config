# Integration, Differences, and Complete Workflow Guide

## Part 1: How This Plan Integrates with the Compound Engineering Plugin

### The Plugin's Architecture

The Compound Engineering plugin provides:

```
Plugin Layer (Already Installed)
├── /compound-engineering:workflows:plan    → Creates detailed plans
├── /compound-engineering:workflows:work    → Executes plans systematically
├── /compound-engineering:workflows:review  → Multi-agent code review
├── 17+ Specialized Agents                  → Security, performance, architecture, etc.
└── Core Philosophy                         → Each unit of work makes the next easier
```

### What This Plan Adds

Your custom SME layer sits ON TOP of the plugin:

```
Your SME Layer (This Plan)
├── /sme-prototype                          → Guided workflow with permission explanations
├── SME Standards Enforcement               → Production-ready structure guaranteed
├── Permission Explainer Hook               → Clarity before every decision
├── security-gate agent                     → SME-specific security review
├── production-ready agent                  → Handoff readiness assessment
└── Templates                               → Consistent project structure
         │
         │ USES
         ▼
Plugin Layer (Compound Engineering)
├── /compound-engineering:workflows:plan
├── /compound-engineering:workflows:work
├── /compound-engineering:workflows:review
└── All specialized agents
```

### Integration Points

| Your Component | Uses From Plugin | How They Connect |
|----------------|------------------|------------------|
| `/sme-prototype` | All `/compound-engineering:workflows:*` | Your command guides WHEN to use plugin commands |
| `security-gate` agent | `security-sentinel` agent | Your agent adds SME-specific checks on top |
| `production-ready` agent | Multiple review agents | Synthesizes their output for handoff assessment |
| CLAUDE.md template | Plugin's compounding philosophy | Pre-populates with SME standards |
| Permission explainer | Plugin's hooks system | Adds structured explanations before choices |

### Concrete Example of Integration

When you run `/sme-prototype` and say "I want to add a SharePoint integration":

```
1. YOUR /sme-prototype command activates
   ↓
2. It determines this is "Feature Development" (Fidelity 2)
   ↓
3. It invokes PLUGIN's /compound-engineering:workflows:plan
   ↓
4. Plugin researches codebase, best practices, proposes approaches
   ↓
5. YOUR CLAUDE.md ensures it follows SME standards (swappable services, demo mode, etc.)
   ↓
6. You approve plan
   ↓
7. /sme-prototype invokes PLUGIN's /compound-engineering:workflows:work
   ↓
8. YOUR permission-explainer hook fires before each file write
   ↓
9. Work completes
   ↓
10. /sme-prototype invokes PLUGIN's /compound-engineering:workflows:review
    ↓
11. YOUR security-gate and production-ready agents run AFTER plugin's 12 agents
    ↓
12. Final output with SME-specific handoff notes
```

---

## Part 2: How This Differs from Standard Plugin Use

### Standard Plugin Approach (For Developers)

The plugin assumes you:
- Understand software architecture decisions
- Can evaluate security implications yourself
- Know what "production-ready" means
- Can structure projects appropriately
- Will create your own standards

### Your SME Approach (For Non-Developers Managing Prototypes)

Your layer adds:
- **Guardrails**: Cannot accidentally violate SME standards
- **Guided decisions**: Explanations before every permission choice
- **Structured output**: Every project has consistent, handoff-ready structure
- **Safety nets**: Security and readiness checks specific to your org's needs
- **Templates**: Don't need to know what files to create

### Key Differences Table

| Aspect | Standard Plugin | Your SME Layer |
|--------|-----------------|----------------|
| **Project Structure** | You decide | Pre-defined by SME Standards |
| **Permission Decisions** | Quick prompts | Full explanations with risk levels |
| **Security Review** | General vulnerabilities | SME-specific (no browser secrets, demo mode) |
| **"Done" Definition** | You decide | Handoff readiness score |
| **Integration Pattern** | Any approach | Must be swappable with mock |
| **Testing Expectation** | Flexible | TDD with demo mode requirement |
| **Documentation** | Optional | Required handoff README |

### What You DON'T Need to Know

Because of your SME layer, you don't need to:
- Know the "right" folder structure (template provides it)
- Understand security best practices deeply (agents check for you)
- Remember to create mock services (template reminds/enforces)
- Know when something is production-ready (agent scores it)
- Understand git branching strategies (workflow handles it)

---

## Part 3: Where to Save Files for Maximum Effect

### File Location Strategy

Claude Code looks for files in a specific hierarchy. Here's where each file should go:

```
Three Levels of Configuration
==============================

1. GLOBAL (All Projects, All Machines)
   ~/.claude/
   ├── settings.json       ← Your default permissions
   └── commands/
       └── sme-prototype.md ← Your main command (available everywhere)

2. PROJECT (This Specific Codebase)
   your-project/
   ├── .claude/
   │   ├── settings.json   ← Project-specific permissions
   │   ├── commands/       ← Project-specific commands
   │   └── agents/         ← Project-specific agents
   ├── CLAUDE.md           ← Project context and rules
   └── ...

3. DIRECTORY (Specific Folder Within Project)
   your-project/
   ├── lib/
   │   └── CLAUDE.md       ← Rules just for /lib code
   └── app/
       └── CLAUDE.md       ← Rules just for /app code
```

### Recommended Setup for Your Role

**Step 1: Global Setup (Do Once)**

```bash
# Create global Claude config directory
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/hooks

# Copy your universal commands
cp templates/.claude/commands/sme-prototype.md ~/.claude/commands/

# Copy your universal agents
cp templates/.claude/agents/security-gate.md ~/.claude/agents/
cp templates/.claude/agents/production-ready.md ~/.claude/agents/

# Copy permission settings (as a base)
cp templates/.claude/settings.json ~/.claude/settings.json
```

This means `/sme-prototype` works in ANY project you open.

**Step 2: Per-Project Setup (Each New Project)**

```bash
# In your new project directory
mkdir -p .claude/commands .claude/agents

# Copy the CLAUDE.md template and customize it
cp templates/CLAUDE.md.template ./CLAUDE.md
# Then edit CLAUDE.md to add project-specific details

# Optionally add project-specific agents or commands
# (The global ones will already work)
```

**Step 3: Template Storage (Keep Templates Accessible)**

Keep your templates in a consistent location you can access from any project:

```
~/claude-projects/Protocall/Compound Engineering/templates/
├── CLAUDE.md.template
├── NEW_PROJECT_SETUP.md
└── .claude/
    ├── settings.json
    ├── commands/
    ├── agents/
    └── hooks/
```

### Configuration Precedence

When Claude Code runs, it merges configurations:

```
Project .claude/ settings  (highest priority - wins conflicts)
    ↓ merged with
Global ~/.claude/ settings
    ↓ merged with
Plugin settings
    ↓ merged with
Claude Code defaults      (lowest priority)
```

This means:
- Your `/sme-prototype` command (global) is always available
- Project-specific CLAUDE.md overrides general rules for that project
- You can have stricter rules per-project if needed

---

## Part 4: How to Test Effectiveness

### Testing Framework

Create measurable checkpoints at each stage:

#### Test 1: Project Setup Consistency

**Goal**: Every new project has correct structure

**Test**:
1. Create a new project using your setup guide
2. Run this checklist (have Claude run it):

```
Project Structure Verification
==============================
[ ] /app directory exists
[ ] /app/api directory exists
[ ] /lib/config.ts exists
[ ] /lib/types.ts exists
[ ] /lib/services/index.ts exists
[ ] /lib/services/mockService.ts exists
[ ] /lib/services/realService.ts exists
[ ] CLAUDE.md exists with SME standards
[ ] .claude/settings.json exists
[ ] .env.example exists
[ ] Demo mode works (DEMO_MODE=true npm run dev)
```

**Success Criteria**: 100% of items checked

#### Test 2: Permission Clarity

**Goal**: You understand every permission before deciding

**Test**:
1. Start a feature that requires file writes
2. Track: Did you receive structured explanation before each permission?
3. Rate understanding: Could you explain to someone else why you allowed/denied?

**Tracking Template**:
```
Permission Log - [Date]
=======================
Permission 1: [Action]
- Explanation received: Yes/No
- Risk level stated: Yes/No
- "Always allow" implications explained: Yes/No
- My understanding (1-5): ___

Permission 2: [Action]
...
```

**Success Criteria**: All permissions have explanations, understanding consistently 4+

#### Test 3: Standards Compliance

**Goal**: Finished code meets SME standards without manual checking

**Test**:
1. Complete a small feature
2. Run `production-ready` agent
3. Check scores

**Success Criteria**:
- Architecture: 5/5
- Integration Pattern: 5/5
- Security: 4+/5
- Documentation: 4+/5
- Testing: 3+/5

#### Test 4: Handoff Quality

**Goal**: Software Engineering can understand and work with your code

**Test** (requires SWE collaboration):
1. Complete a prototype
2. Have SWE review without your explanation
3. Ask them to rate:
   - Could you run this locally? (Yes/No)
   - Is it clear what to implement? (1-5)
   - Are swap points obvious? (1-5)
   - Could you estimate effort to productionize? (1-5)

**Success Criteria**: All Yes, all ratings 4+

#### Test 5: Compounding Effect

**Goal**: Each project is faster than the last

**Test**:
1. Track time from "vague idea" to "handoff ready" for first 3 projects
2. Track number of "lessons learned" added to CLAUDE.md
3. Track reduction in review findings

**Tracking Template**:
```
Project Velocity Log
====================
Project 1: [Name]
- Planning time: ___ hours
- Execution time: ___ hours
- Review cycles: ___
- Lessons captured: ___

Project 2: [Name]
...
```

**Success Criteria**: Time decreasing, lessons increasing, review cycles decreasing

### Quick Effectiveness Check

After any significant work, ask Claude:

```
Run effectiveness check:
1. Does the project structure match SME standards?
2. Are all integrations swappable?
3. Does demo mode work?
4. What's the production-readiness score?
5. What lessons from this work should we capture?
```

---

## Part 5: Step-by-Step Workflow from Vague Idea to Handoff

### The Complete Journey

```
VAGUE IDEA
    ↓
[Phase 0: Clarify]
    ↓
CLEAR CONCEPT
    ↓
[Phase 1: Setup]
    ↓
PROJECT SKELETON
    ↓
[Phase 2: Plan]
    ↓
APPROVED PLAN
    ↓
[Phase 3: Build]
    ↓
WORKING PROTOTYPE
    ↓
[Phase 4: Review]
    ↓
QUALITY-CHECKED CODE
    ↓
[Phase 5: Compound]
    ↓
LESSONS CAPTURED
    ↓
[Phase 6: Handoff]
    ↓
READY FOR SWE
```

---

### Phase 0: Clarify the Vague Idea (30 min - 2 hours)

**You have**: A vague sense of what an SME needs
**You need**: A clear concept you can explain in one paragraph

#### Step 0.1: Stakeholder Conversation

Talk to the SME who needs this. Ask:
- What problem are they trying to solve?
- What do they do today without this tool?
- What would "success" look like?
- Who else uses the data involved?

#### Step 0.2: Write the One-Pager

Before touching Claude Code, write (or dictate):

```
PROTOTYPE CONCEPT: [Name]
=========================

PROBLEM:
[2-3 sentences describing the pain point]

SOLUTION:
[2-3 sentences describing what the app does]

USERS:
[Who will use this and how often]

KEY FEATURES:
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

INTEGRATIONS NEEDED:
- [SharePoint list? Internal API? Database?]

SUCCESS LOOKS LIKE:
[What would make this worth building]
```

#### Step 0.3: Determine Fidelity

Based on your concept:

- **Fidelity 1** (1-2 features, very clear): Skip to Phase 3
- **Fidelity 2** (3-5 features, mostly clear): Standard workflow
- **Fidelity 3** (Complex, unclear requirements): Need prototyping first

For Fidelity 3, add a sub-phase:
```
Create throwaway prototypes to clarify requirements:
1. "Build a quick mockup of [unclear feature]"
2. Click through it
3. Note what's wrong or confusing
4. Refine concept
5. Then proceed with standard workflow
```

---

### Phase 1: Project Setup (15-30 min)

**You have**: Clear concept
**You need**: Project skeleton ready for development

#### Step 1.1: Create Project

```bash
# Terminal commands
npx create-next-app@latest [project-name] --typescript --app --eslint
cd [project-name]
```

#### Step 1.2: Apply Templates

```bash
# Copy your global command (if not already in ~/.claude/)
mkdir -p .claude

# Copy CLAUDE.md template
cp ~/claude-projects/Protocall/Compound\ Engineering/templates/CLAUDE.md.template ./CLAUDE.md
```

#### Step 1.3: Customize CLAUDE.md

Open CLAUDE.md and fill in:
- Project name
- Specific integrations needed
- Any project-specific rules

#### Step 1.4: Run Setup Scaffold

```
# In Claude Code
/sme-prototype

Then say:
"I'm setting up a new project. Here's the concept:
[Paste your one-pager from Phase 0]

Please create the initial project structure including:
- lib/config.ts
- lib/types.ts
- lib/services with mock implementation
- Initial health check API route
- Verify demo mode works"
```

#### Step 1.5: Verify Setup

```
# Should work without errors
DEMO_MODE=true npm run dev

# Test health endpoint
curl http://localhost:3000/api/health
```

**Checkpoint**: Project runs in demo mode, basic structure in place.

---

### Phase 2: Plan (1-4 hours depending on complexity)

**You have**: Working project skeleton
**You need**: Detailed, approved implementation plan

#### Step 2.1: Start Planning

```
/compound-engineering:workflows:plan

"I need to build [project name] with these features:
[List from your one-pager]

The integrations are:
[List integrations]

Please research:
1. How similar features are typically built
2. Best practices for these integrations
3. Any existing patterns in common frameworks

Then create a detailed plan with:
- Acceptance criteria I can verify
- Proposed file structure
- API endpoints needed
- Testing approach"
```

#### Step 2.2: Review the Plan

Claude will produce a detailed plan. Review for:

**Check 1: Completeness**
- Does it cover all features from your concept?
- Are there acceptance criteria for each?

**Check 2: SME Standards Compliance**
- Does it mention swappable services?
- Is demo mode considered?
- Are API routes server-side only?

**Check 3: Feasibility**
- Does the scope match your timeline?
- Are there any "I don't know how to do this" areas?

#### Step 2.3: Refine if Needed

Common refinement requests:
- "This is too complex. What's the simplest version that works?"
- "Add demo mode handling for [feature]"
- "Break [big feature] into smaller steps"
- "What are the risks with [approach]?"

#### Step 2.4: Approve the Plan

When satisfied:
```
"This plan looks good. Save it to docs/plan-[feature].md and let's proceed."
```

**Checkpoint**: Written plan exists, you understand and approve it.

---

### Phase 3: Build (Hours to Days depending on scope)

**You have**: Approved plan
**You need**: Working prototype

#### Step 3.1: Start Execution

```
/compound-engineering:workflows:work docs/plan-[feature].md
```

This will:
1. Create a feature branch
2. Break plan into todos
3. Execute systematically
4. Run tests after each change

#### Step 3.2: Monitor Progress

You'll see Claude working through todos. Your job:
- **Answer questions** when Claude asks for clarification
- **Review permission requests** (you'll get full explanations)
- **Spot-check progress** every 15-30 minutes

#### Step 3.3: Handle Permission Decisions

For each permission, you'll see:
```
PERMISSION REQUEST
==================
ACTION: [what]
PURPOSE: [why]
RISK: [level]
"ALWAYS ALLOW" MEANS: [implications]
RECOMMENDATION: [suggestion]
```

Guidelines:
- **Allow Once**: When unsure or first time seeing this
- **Allow for Session**: For repeated safe operations in current session
- **Always Allow**: Only for well-understood, low-risk patterns
- **Deny**: If anything seems off

#### Step 3.4: Test Incrementally

After each major piece:
```
"Show me what we have so far. Run the app in demo mode and walk me through [feature]."
```

#### Step 3.5: Handle Blockers

If Claude gets stuck:
```
"You seem stuck on [issue]. Let's step back:
1. What are you trying to accomplish?
2. What's preventing it?
3. What are three different approaches we could try?"
```

**Checkpoint**: Features work in demo mode, tests pass.

---

### Phase 4: Review (1-2 hours)

**You have**: Working code
**You need**: Quality-verified, secure code

#### Step 4.1: Run Full Review

```
/compound-engineering:workflows:review
```

This runs 12+ review agents checking:
- Security vulnerabilities
- Performance issues
- Architectural concerns
- Code simplicity
- Best practices

#### Step 4.2: Run SME-Specific Reviews

```
# Run your custom agents
"Run the security-gate agent on the current changes"
"Run the production-ready agent and show me the scores"
```

#### Step 4.3: Triage Findings

You'll get a list of findings. For each:

**Accept**: "Yes, fix this"
**Defer**: "Note this for later, but don't fix now"
**Dismiss**: "This isn't actually an issue because [reason]"

```
/compound-engineering:triage
```

#### Step 4.4: Address Critical Items

For accepted findings:
```
"Fix the security issues identified. For each fix, explain what you changed and why."
```

#### Step 4.5: Verify Scores

After fixes:
```
"Run production-ready agent again. What's the new score?"
```

**Target Scores**:
- Architecture: 5/5
- Integration: 5/5
- Security: 4+/5
- Documentation: 4+/5
- Testing: 3+/5

**Checkpoint**: Production-ready score of 20+/25, no critical security issues.

---

### Phase 5: Compound (30 min)

**You have**: Quality code
**You need**: Lessons captured for future

#### Step 5.1: Reflect on the Build

```
"Let's capture learnings from this project:
1. What patterns did we establish that should apply to future projects?
2. What mistakes did we make that we should prevent next time?
3. What decisions did we make that should be documented?
4. What would make the next similar project faster?"
```

#### Step 5.2: Update CLAUDE.md

```
"Add the following learnings to CLAUDE.md under 'Lessons Learned':
[List from Step 5.1]"
```

#### Step 5.3: Document Decisions

```
"Create a decision record in docs/decisions/ for the key architectural decisions in this project."
```

#### Step 5.4: Update Templates (if broadly applicable)

If you discovered something that should apply to ALL future projects:
```
"This pattern should apply to all SME prototypes. Update the CLAUDE.md template in the templates folder."
```

**Checkpoint**: Lessons documented, next project will be faster.

---

### Phase 6: Handoff (1-2 hours)

**You have**: Complete, reviewed, documented prototype
**You need**: Package ready for Software Engineering

#### Step 6.1: Generate Handoff Documentation

```
"Generate the handoff README.md with:
1. What the app does (one paragraph)
2. How to run in demo mode
3. Architecture overview
4. Integration points and swap instructions
5. What's production-ready vs needs hardening
6. Known limitations
7. Estimated effort for SWE"
```

#### Step 6.2: Verify Demo Mode One Last Time

```bash
# Fresh clone test
cd ..
git clone [your-repo] test-clone
cd test-clone
npm install
DEMO_MODE=true npm run dev
```

Everything should work without any external dependencies.

#### Step 6.3: Create PR/Package

```
"Create a pull request with:
- Title: [Project Name] - SME Prototype Ready for Review
- Summary of what was built
- Link to handoff documentation
- Production-readiness score
- List of files changed"
```

#### Step 6.4: Handoff Meeting Prep

Prepare to walk SWE through:
1. **Demo**: Show it working (in demo mode)
2. **Architecture**: Point to key files and patterns
3. **Swap Points**: Where they need to implement real integrations
4. **Questions**: What decisions you're unsure about

**Checkpoint**: SWE has everything they need to evaluate and productionize.

---

## Summary: The Complete Flow

```
Day 0 (30 min - 2 hours)
├── Talk to SME stakeholder
├── Write one-pager concept
└── Determine fidelity level

Day 1 (2-4 hours)
├── Create project with template
├── Run /compound-engineering:workflows:plan
├── Review and approve plan
└── Save plan to docs/

Days 2-N (varies by scope)
├── Run /compound-engineering:workflows:work
├── Monitor progress, answer questions
├── Review permission decisions (with explanations)
└── Test incrementally in demo mode

Day N+1 (2-3 hours)
├── Run /compound-engineering:workflows:review
├── Run security-gate and production-ready agents
├── Triage and fix findings
├── Verify production-ready score 20+/25
├── Capture lessons in CLAUDE.md
└── Generate handoff documentation

Handoff
├── Fresh clone demo mode test
├── Create PR
└── Walk SWE through code
```

---

## Quick Reference Card

| I want to... | Command/Action |
|--------------|----------------|
| Start any work | `/sme-prototype` |
| Plan a feature | `/compound-engineering:workflows:plan` |
| Execute a plan | `/compound-engineering:workflows:work [plan-file]` |
| Review code | `/compound-engineering:workflows:review` |
| Check security | "Run security-gate agent" |
| Check readiness | "Run production-ready agent" |
| Capture learnings | "Add to CLAUDE.md: [lesson]" |
| Understand a permission | Read the explanation provided |
| Stop something going wrong | Press `Escape` |
| Undo recent changes | Press `Escape` twice |
