# Feature Specification: Rhythm Window Positioning

**Feature Branch**: `003-rhythm-window-positioning`

**Created**: 21 August 2026

**Status**: Draft

**Input**: User description: The RhythmPluginTool resource output has had its windows removed in favour of just keeping the timestamp - ensure this does not change. Add a position field to the RhythmTimingWindow resource script. Then create an algorithm to work out the position of the timing window and where it should be displayed on screen as if displaying a 2d graphic in a 2d scene. The following inputs should be added, "MinRadius" "MaxRadius" under an export category "Hit Marker Positioning". The algorithm should then generate a position for each timestamp on the screen ensuring it's a certain distance (50px) away from the screens boundary and a certain distance (randomised distance away factoring the MinRadius & MaxRadius as part of the random calculation). Once the position has been determined, it should be saved in the "RhythmTimingWindow" resource along with the timestamp.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic Hit Marker Positioning (Priority: P1)

As a rhythm game developer, I want timing windows to have automatically generated screen positions so that I can visualize hit markers without manual coordinate setting.

**Why this priority**: This is the core functional requirement requested.

**Independent Test**: Verify that when a rhythm song is processed, all generated `RhythmTimingWindow` instances contain a valid `position` vector.

**Acceptance Scenarios**:

1. **Given** a song with processed timestamps, **When** the algorithm runs, **Then** all `RhythmTimingWindow` instances in the resulting resource have a `position` property populated.
2. **Given** the "Hit Marker Positioning" settings, **When** the algorithm runs, **Then** the generated `position` for each window is at least 50px from the screen boundary.
3. **Given** the "Hit Marker Positioning" settings, **When** the algorithm runs, **Then** the generated `position` for each window falls within the randomized distance range defined by `MinRadius` and `MaxRadius`.

---

### User Story 2 - Preserving Existing Rhythm Data (Priority: P1)

As a developer, I want existing timing window timestamps to remain unchanged so that rhythm detection functionality is preserved.

**Why this priority**: Ensures no regression in existing features.

**Independent Test**: Verify that the generated timestamps in `RhythmTimingWindow` are identical to the input timestamps before and after the positioning algorithm.

**Acceptance Scenarios**:

1. **Given** a set of input timestamps, **When** the positioning algorithm is applied, **Then** the `timestamp` field of each `RhythmTimingWindow` remains unchanged.

---

### Edge Cases

- What happens if `MinRadius` is greater than `MaxRadius`? The system MUST throw a validation error in the editor, as specified in Clarifications.
- How does the system handle cases where the randomized position calculation fails to find a valid spot 50px from the screen boundary?
- How does the system handle scenarios with extremely high numbers of timing windows in a short time, potentially leading to overlapping positions?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST add a `position` (Vector2) field to the `RhythmTimingWindow` resource script.
- **FR-002**: System MUST add `MinRadius` (float) and `MaxRadius` (float) export variables to `RhythmTimingWindow` under the "Hit Marker Positioning" export category.
- **FR-003**: System MUST provide an algorithm to calculate the screen `position` for each `RhythmTimingWindow`.
- **FR-004**: System MUST ensure calculated positions are at least 50px away from the screen boundary.
- **FR-005**: System MUST factor `MinRadius` and `MaxRadius` into the random calculation of the `position`.
- **FR-006**: System MUST persist the calculated `position` in the `RhythmTimingWindow` resource.
- **FR-007**: System MUST NOT modify existing `timestamp` values in `RhythmTimingWindow`.

### Key Entities

- **RhythmTimingWindow**: Represents a specific timing window instance with a `timestamp` and a calculated screen `position`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of generated `RhythmTimingWindow` instances have a populated `position` field.
- **SC-002**: 100% of generated positions pass the boundary check (50px distance from screen edge).
- **SC-003**: Existing `timestamp` values remain identical after positioning calculation.

## Assumptions

- The screen dimensions are available to the algorithm for boundary calculation.
- The algorithm will run when a new `RhythmTimingWindow` is created or when settings are updated.
- Existing tool structures are compatible with the new resource fields.

## Clarifications

### Session 2026-08-21
- Q: How to handle cases where MinRadius > MaxRadius? → A: C - Throw a validation error in the editor.

## Requirements *(mandatory)*
