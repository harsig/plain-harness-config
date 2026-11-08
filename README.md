# plain-harness-config

Example configuration for [plain-harness](https://github.com/harsig/plain-harness): a main agent that hands every date or time question to a sub-agent.

| Folder | Agent |
| --- | --- |
| `main-agent/` | Talks to the user. Its only tool is `date_agent` (served by [scripts-mcp](https://github.com/harsig/scripts-mcp) from `scripts/date-agent.sh`), which runs the sub-agent as a stateless `plain-harness` call. |
| `sub-agent/` | Answers date and time questions with the `date` script from [scripts](https://github.com/harsig/scripts) and the `date-output` skill from [skills](https://github.com/harsig/skills) (served by [skills-mcp](https://github.com/harsig/skills-mcp)). |

Each agent's system prompt is built from two files in its `prompts/` folder, concatenated in order (`system_prompt_files` in `plain-harness.yml`):

| File | Contains |
| --- | --- |
| `SOUL.md` | Identity, values and voice: who the agent is, independent of any tool. |
| `AGENT.md` | Role, available tools, working rules and output format for this setup. |

Both agents use an OpenAI-compatible server at `http://localhost:8080/v1` (for example llama.cpp); change `model` in the two `plain-harness.yml` files to use another one.

## Setup

The configuration uses relative paths and expects this repository next to the tool repositories:

```text
<folder>/
  plain-harness/        ./build.sh
  scripts-mcp/          ./build.sh
  skills-mcp/           ./build.sh
  plain-harness-config/ (this repository)
```

Build plain-harness and skills-mcp, then set up everything from the main agent (run this again to update):

```sh
../plain-harness/bin/plain-harness --config main-agent/plain-harness.yml --setup
```

This clones and builds the main agent's scripts-mcp, then runs the sub-agent's setup (its top-level `setup`), which clones and builds the sub-agent's scripts-mcp and clones the scripts and skills its tools serve.

## Run

```sh
cd main-agent
../../plain-harness/bin/plain-harness --session demo "What time is it in Tokyo?"
```

Sessions and cloned repositories are runtime state and are not committed (see `.gitignore`).
