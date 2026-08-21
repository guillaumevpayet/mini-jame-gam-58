# Data Model: Rhythm Timing Window

## Entities

### RhythmTimingWindow
Represents the timing window resource used for hit detection and visualization.

- **Fields**:
  - `timestamp` (float): The time offset of the hit window (existing).
  - `position` (Vector2): The screen position for hit marker visualization (new).
  - `MinRadius` (float): Minimum randomized distance for position (new).
  - `MaxRadius` (float): Maximum randomized distance for position (new).

- **Relationships**: None (standalone resource).

- **Constraints**:
  - `timestamp` MUST NOT be modified.
  - `position` MUST be calculated based on screen bounds (50px margin) and `MinRadius`/`MaxRadius`.
  - Invalid `MinRadius`/`MaxRadius` combinations (Min > Max) MUST trigger an editor validation error.
