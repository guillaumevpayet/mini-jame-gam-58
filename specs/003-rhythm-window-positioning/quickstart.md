# Quickstart: Rhythm Window Positioning Validation

## Prerequisites
- Rhythm game project setup in Godot.
- `RhythmTimingWindow` resource script updated with new fields and algorithm.

## Validation Scenarios

### Scenario 1: Automatic Position Generation
1. Open a `RhythmTimingWindow` resource in the Godot Inspector.
2. Ensure `MinRadius` and `MaxRadius` are set to valid values (e.g., `100`, `200`).
3. Trigger the positioning calculation (via the tool interface).
4. Verify the `position` field in the inspector is populated with a Vector2.
5. Verify the `timestamp` field remains unchanged.
6. Verify the position is visually at least 50px away from the screen boundary.

### Scenario 2: Radius Validation
1. Set `MinRadius` to `200` and `MaxRadius` to `100`.
2. Trigger the positioning calculation.
3. Verify an error is logged in the editor console.
