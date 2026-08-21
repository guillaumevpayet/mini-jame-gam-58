# Godot Project Constitution

## Core Principles

### I. GDScript Standards
All GDScript code must follow strict naming conventions: `snake_case` for functions and variables, `PascalCase` for classes and nodes. Type hints MUST be used for all function signatures and variable declarations to ensure maintainability.

### II. Project Structure & YAGNI
Maintain the existing project directory structure and naming conventions. Deviations from established architectural patterns require explicit justification and review. Adhere to YAGNI (You Ain't Gonna Need It) principles. Start simple and only increase complexity when required by concrete feature needs.

### III. Testing Policy (NON-NEGOTIABLE)
Automated unit, E2E, and integration tests are prohibited. All verification MUST be performed manually to ensure behavioral correctness. No external testing frameworks (e.g., pytest, Gut) are allowed.

## Development Constraints

### I. Tooling & Environment
- Project built on the Godot Engine using GDScript.
- No Google searches to be carried out.
- No online posts or contact to be made.
- No git commands to be run.

### II. Safety & Governance
- Code reviews must prioritize architectural compliance and readability.
- Deletion of files MUST always require manual approval.
- Any deviation from established architectural patterns requires explicit justification and review.

**Version**: 1.0.0 | **Ratified**: 2026-08-21 | **Last Amended**: 2026-08-21
