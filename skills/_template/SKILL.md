---
name: template_skill
description: "Describe what the skill does and when the agent should use it. Be specific about the use cases and limitations. This text is heavily used by the agent to determine if the skill is appropriate for a task."
homepage: https://github.com/win4r/OpenClaw-Skill
metadata: { "openclaw": { "emoji": "🛠️", "requires": { "bins": ["req_binary_1"] } } }
---

# Template Skill

A brief overview of what this skill accomplishes.

## When to Use

✅ **USE this skill when:**

- Specifically listing scenarios where this skill is the best fit.
- "Example user prompt"

## When NOT to Use

❌ **DON'T use this skill when:**

- Listing scenarios that might seem related but are better handled by other skills or unsupported.

## Commands

### Basic Usage

```bash
# Example bash command using the skill
echo "Hello from the Template Skill"
```

### Advanced Usage

```bash
# Example of more advanced usage with parameters
./scripts/custom_script.sh --param value
```

## Quick Responses

**"How do I use the template?"**

```bash
echo "Just copy this directory and rename the properties in SKILL.md"
```

## Notes

- Any caveats, rate limits, or special considerations for the agent when using this skill.
- API key requirements if applicable.
