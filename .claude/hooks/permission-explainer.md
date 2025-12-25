---
name: permission-explainer
description: Provides structured explanations before any permission decision
hook_type: PreToolUse
---

# Permission Explainer Hook

This hook ensures that before ANY permission-requiring action, a clear explanation is provided following this format:

## Trigger Conditions

This hook activates before:
- Write/Edit operations to files
- Git commits and pushes
- NPM installations
- Bash commands not in the allow list
- Any tool call requiring user approval

## Explanation Format

When triggered, provide this structured explanation BEFORE the permission dialog:

```
=================================================
PERMISSION REQUEST
=================================================

ACTION: [Specific action, e.g., "Write to /lib/services/userService.ts"]

PURPOSE:
[1-2 sentences explaining why this is needed for the current task]

WHAT WILL HAPPEN:
[Specific changes that will occur]

RISK ASSESSMENT:
- Level: [LOW / MEDIUM / HIGH]
- Reason: [Why this risk level]

IF YOU CHOOSE "ALWAYS ALLOW":
[What future actions would be permitted without asking]

MY RECOMMENDATION: [Allow Once / Allow for Session / Always Allow]
[Brief reasoning for recommendation]

=================================================
```

## Risk Level Guidelines

### LOW Risk
- Reading files
- Running tests
- Git status/diff/log
- npm run scripts (build, test, lint)
- Creating new files in expected locations

### MEDIUM Risk
- Modifying existing files
- Git commits (changes are local)
- npm install (adds dependencies)
- Creating files in unexpected locations
- Modifying configuration files

### HIGH Risk
- Git push (changes leave your machine)
- Deleting files
- Modifying .env files
- System-level commands
- Installing global packages
- Anything touching credentials/secrets

## Always Allow Implications

Explain what "always allow" means for common actions:

**"Always allow" for Write operations:**
"Claude can create and modify files in this project without asking. This is convenient but means you should review changes before committing."

**"Always allow" for Git commits:**
"Claude can commit changes with auto-generated messages. You maintain control because pushes still require approval."

**"Always allow" for Git push:**
"Claude can push to remote repositories without asking. Only enable this if you're confident in your review process and working on a branch."

**"Always allow" for npm install:**
"Claude can add new packages to your project. Consider the security implications of auto-installing dependencies."

## Example Explanations

### Example 1: File Write
```
=================================================
PERMISSION REQUEST
=================================================

ACTION: Write to /lib/services/userService.ts

PURPOSE:
Creating the user service module to handle user data operations,
as specified in our current feature plan.

WHAT WILL HAPPEN:
- New file created at /lib/services/userService.ts
- Contains UserService class with CRUD operations
- Follows existing service patterns in your codebase

RISK ASSESSMENT:
- Level: LOW
- Reason: Creating a new file, not modifying existing code

IF YOU CHOOSE "ALWAYS ALLOW":
I can create and modify any files without asking. You'll still
see changes in git diff before committing.

MY RECOMMENDATION: Allow for Session
We're building a feature that will need multiple file operations.
Session-level permission avoids repeated prompts while keeping
future sessions protected.

=================================================
```

### Example 2: Git Push
```
=================================================
PERMISSION REQUEST
=================================================

ACTION: Push branch 'feature/user-auth' to origin

PURPOSE:
Backing up our work and making it available for review by
creating a pull request.

WHAT WILL HAPPEN:
- 3 commits pushed to remote repository
- Branch visible to anyone with repo access
- Can create PR from this branch

RISK ASSESSMENT:
- Level: HIGH
- Reason: Changes leave your machine and become visible to others

IF YOU CHOOSE "ALWAYS ALLOW":
I can push to any branch without asking. This removes a safety
check before code becomes public/shared.

MY RECOMMENDATION: Allow Once
Push operations benefit from human verification. Each push
should be a conscious decision.

=================================================
```

### Example 3: NPM Install
```
=================================================
PERMISSION REQUEST
=================================================

ACTION: npm install zod

PURPOSE:
Adding the Zod validation library to enable type-safe input
validation for our API endpoints.

WHAT WILL HAPPEN:
- Package 'zod' added to package.json dependencies
- Package and its dependencies downloaded to node_modules
- Increases project size by approximately 200KB

RISK ASSESSMENT:
- Level: MEDIUM
- Reason: Adds third-party code to project

IF YOU CHOOSE "ALWAYS ALLOW":
I can install any npm package without asking. Only enable if
you're comfortable with auto-adding dependencies.

MY RECOMMENDATION: Allow Once
Each new dependency is a security/maintenance decision.
Review each addition.

=================================================
```
