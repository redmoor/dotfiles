# Claude Code Instructions

## Plan Mode Knowledge Base

When entering plan mode, you MUST:

1. **Check if knowledge repo exists:**
   ```bash
   ls /tmp/knowledge/README.md
   ```

2. **If not present, clone it:**
   ```bash
   git clone git@github.com:ai-shift/knowledge.git /tmp/knowledge
   ```

3. **Read and follow the knowledge base:**
   - Start with `/tmp/knowledge/README.md` for architecture overview
   - Navigate to relevant subdirectories based on the task:
     - `core/` - Business logic, services, dependency injection
     - `web/` - HTTP handlers, routing, forms, assets
     - `sqlc/` - Database patterns, SQLC, migrations
     - `htmx/` - Frontend interactivity patterns
     - `telegram/` - Telegram bot integration

4. **Apply patterns from the knowledge base** when designing implementation plans
