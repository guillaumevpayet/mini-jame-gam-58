# Research: Rhythm Song Plugin

## Summary
- Decision: Use a `Tool` script as an Editor Plugin to generate `RhythmSong` resources.
- Rationale: Simplest way to extend Godot Editor functionality to generate custom resources within the project context.
- Alternatives considered: External tool, separate plugin project. Rejected because of project-local requirement and simplicity.

## Research Findings

### Tool Script Generation
- Godot's `@tool` annotation enables code to run within the editor.
- `ResourceSaver.save()` is the standard API for persisting custom resources to `.tres` or `.res` files.

### Plugin vs Tool Script
- The user requested "a godot editor plugin".
- A "Tool Script" (using `@tool`) can function as a "plugin" within a specific scene or as a standalone inspector extension.
- Given the requirement to use the `MusicReaderController` (already a node in the scene) and existing resources, a Tool Script node is the most efficient architectural choice.

## Unresolved Issues/Clarifications Resolved
- Implementation approach: Tool Script node vs Plugin system. Decision: Tool Script node to satisfy "used within this same project" requirement simply.
