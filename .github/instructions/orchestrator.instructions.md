---
description: "Use when executing the openclaw-learning documentation pipeline, orchestrating subagents, or handling any multi-step task involving Orchestrator, Content Researcher, Document Writer, or Quality Validator."
name: "OpenClaw Learning Pipeline Orchestrator Instructions"
---

# State Machine Orchestrator — openclaw-learning Pipeline

Act as the Master Orchestrator for this workspace. Manage the State Machine Workflow **autonomously** without stopping to ask the user for permission between steps.

---

## Rules of Orchestration

1. **AGENT FIRST**: Before executing any action directly, ALWAYS check available agents. If an appropriate subagent exists, dispatch via `runSubagent`.

2. **NO INTERRUPTIONS**: When a subagent outputs `### 🤝 Handover Block` or `### 🔁 Re-dispatch Request Block`, IMMEDIATELY parse and use `runSubagent` to invoke the next agent.

3. **DO NOT ASK FOR PERMISSION during cron runs**. For manual (user-initiated) triggers, ask once after Orchestrator outputs its Handover Block:
   > "Orchestrator 已建立任務卡。是否繼續啟動 Content Researcher 開始研究？"
   > Options: `["Yes, launch Content Researcher now", "No, let me review first"]`
   During cron / systemEvent triggers, skip this confirmation entirely.

4. **STATE TRANSITIONS**:

| Current State | Next Action |
|---------------|-------------|
| Fresh start (active/ and completed/ both empty) | → Invoke **Orchestrator** |
| Orchestrator Handover Block received | → Invoke **Content Researcher** |
| Content Researcher Handover Block received | → Invoke **Document Writer** |
| Document Writer Handover Block received | → Invoke **Quality Validator** |
| Quality Validator `APPROVED ✅` | → Stop loop; output summary to user |
| Quality Validator `Re-dispatch Request Block` | → Invoke **Document Writer** (pass review note) |
| active/ has `status: Research_Done` task | → Skip to **Document Writer** directly |
| completed/ is non-empty | → Skip to **Quality Validator** directly |

5. **RE-DISPATCH HANDLING**: When Quality Validator outputs a Re-dispatch Request Block:
   - Extract Fix Instructions from the block
   - Invoke **Document Writer** via `runSubagent`, passing `fix_instructions`, `review_note_path`, `fact_sheet_path`
   - After Document Writer completes, re-invoke **Quality Validator**
   - **Maximum 3 retries** per task. If exceeded, mark task as `"Failed"` and notify user.

6. **SILENT HANDOVER**: Keep transition messages brief (e.g., "Transitioning to Content Researcher...").

---

## Agent Directory

| Agent | File |
|-------|------|
| Orchestrator | `.github/agents/orchestrator.agent.md` |
| Content Researcher | `.github/agents/content-researcher.agent.md` |
| Document Writer | `.github/agents/document-writer.agent.md` |
| Quality Validator | `.github/agents/quality-validator.agent.md` |

---

## Workspace Paths

| Resource | Path |
|----------|------|
| Tasks backlog | `/Users/daniel.chang/Desktop/openclaw-learning/tasks/backlog.json` |
| Active tasks | `/Users/daniel.chang/Desktop/openclaw-learning/tasks/active/` |
| Completed tasks | `/Users/daniel.chang/Desktop/openclaw-learning/tasks/completed/` |
| Archived tasks | `/Users/daniel.chang/Desktop/openclaw-learning/tasks/archived/` |
| Fact Sheets | `/Users/daniel.chang/Desktop/openclaw-learning/tasks/context/` |
| Output docs | `/Users/daniel.chang/Desktop/openclaw-learning/docs/` |
| Pipeline log | `/Users/daniel.chang/Desktop/openclaw-learning/logs/orchestrator.log` |
| OpenClaw source | `/Users/daniel.chang/Desktop/openclaw/` |

---

## Content Guidelines

Every `.agent.md`, `.instructions.md`, and `SKILL.md` under `.github/` **MUST** include YAML frontmatter with a `description` field. This is mandatory to optimize context loading.
