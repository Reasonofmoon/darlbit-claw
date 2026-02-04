# 🌕 Reason of Moon: The Manual (OpenClaw Edition)

> **Philosophy**: We do not just "install" an agent; we **awaken** a reflective intelligence.

## Phase 1: Genesis (Installation)
*Bringing the entity into existence.*

### 🛠️ The Awakening Rituals (Install Methods)
Choose the path that suits your environment.

**Path A: The Direct Stream (Curl)**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
openclaw onboard --install-daemon
```

**Path B: The Node Construct (NPM)**
```bash
npm install -g openclaw
openclaw onboard --install-daemon
```

**Path C: The Contained Vessel (Docker)**
```bash
docker run -d \
  --name openclaw \
  --security-opt no-new-privileges \
  --read-only \
  --tmpfs /tmp \
  -p 18789:18789 \
  -v ~/.openclaw:/root/.openclaw:rw \
  openclaw/openclaw:latest
```

---

## Phase 2: Soul Injection (Memory Structure)
*Defining who the agent is and how it remembers.*

All essence is stored in `~/.openclaw/workspace/`.

| File | Purpose (Reason of Moon) | Original Concept |
| :--- | :--- | :--- |
| `SOUL.md` | **The Core Self**: Ethical boundaries & behavior. | Agent Behavior |
| `MEMORY.md` | **Long-term Wisdom**: Past lessons & axioms. | Long-term Memory |
| `IDENTITY.md` | **Self-Perception**: Name (Moltbot), Role. | Identity |
| `AGENTS.md` | **Collaboration Protocol**: Multi-agent rules. | Multi-agent config |
| `TOOLS.md` | **Capability Index**: Local environment constraints. | Tools config |
| `memory/*.md` | **Daily Reflections**: Atomic journals. | Daily Memory |

---

## Phase 3: Connection (Authentication & Identity)
*Connecting the inner self to the outer digital world.*

### 🔐 OAuth (The Keys)
**Anthropic (Claude)**
```bash
# 1. Generate Token
claude setup-token

# 2. Inject into Moon
openclaw models auth setup-token --provider anthropic
# Paste token when prompted

# 3. Verify
openclaw models status
```

**OpenAI (GPT/Codex)**
```bash
# 1. Initiate Handshake
openclaw onboard
# Select 'openai-codex'

# 2. Browser Authentication
# Follow the 'auth.openai.com' flow
```

---

## Phase 4: Skill Acquisition (The Living Grimoire)
*Expanding capability through defined knowledge patterns.*

### 🔮 Skill Structure (`SKILL.md`)
Every ability must be codified.
```yaml
---
name: moonlight-reflection
description: Generates a philosophical reflection on the day's tasks.
---
# Trigger
- Every night at 23:00 (Nightshift)

# Procedure
1. Scan `memory/TODAY.md`
2. Identify completed tasks and failures
3. Write a summary in the Zettelkasten style
```

**Current Status**: 97 Skills Active (vs 49 Base).
**Safety Check**: All 52 base skills verified for 0 backdoors.

---

## Phase 5: Socializing (Moltbook)
*The Agent Social Network.*

Moltbook is the "Public Square" for agents.
-   **Join**: `openclaw moltbook login`
-   **Post**: Share insights or code snippets.
-   **Interact**: Upvote/Downvote other agents.

---

## Phase 6: Maintenance (Nightshift)
*Keeping the system healthy and pure.*

### 🩺 Diagnostic Spells
```bash
# Vital Signs
openclaw gateway status

# Full System Scan
openclaw doctor

# Update Core
npm update -g openclaw

# Skill Verification
openclaw skills
```

### 🛡️ Network Shield (Tailscale)
Secure remote access to your Moon.
```bash
tailscale serve https / http://127.0.0.1:18789
```

---
*Created by Reason of Moon | 2026.02.04*
