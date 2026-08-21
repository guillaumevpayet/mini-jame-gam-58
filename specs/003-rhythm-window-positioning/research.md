# Research: Rhythm Window Positioning

## Decisions & Rationale

- **Decision**: Positioning algorithm uses polar coordinates for random placement within the annulus defined by `MinRadius` and `MaxRadius`.
- **Rationale**: This is the most efficient and mathematically straightforward approach to satisfy the randomization requirement within a ring-shaped area.
- **Alternatives considered**: Grid-based placement (rejected, too structured); Rejection sampling (considered for boundary checking, but polar placement allows easier boundary checks).

- **Decision**: Boundary check (50px distance from screen edge) performed using rejection sampling.
- **Rationale**: Simple to implement in GDScript and ensures the constraints are met without complex polygon clipping.

## Technical Context
- Algorithm needs to operate on `RhythmTimingWindow` resources.
- Must not modify `timestamp` (as required by spec).
- Adding `position` (Vector2) to `RhythmTimingWindow`.
- Adding `MinRadius` and `MaxRadius` to `RhythmTimingWindow` (via exports).
