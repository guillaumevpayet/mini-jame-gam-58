# Tasks: Rhythm Window Positioning

**Feature**: Rhythm Window Positioning
**Branch**: `003-rhythm-window-positioning`

## Phase 1: Setup

- [X] T001 Initialize workspace structure for rhythm generator feature

## Phase 2: Foundational

- [X] T002 Add position field to addons/rhythm_generator/rhythm_timing_window.gd
- [X] T003 Add MinRadius and MaxRadius export variables to addons/rhythm_generator/rhythm_timing_window.gd
- [X] T004 Add validation logic for MinRadius vs MaxRadius in addons/rhythm_generator/rhythm_timing_window.gd

## Phase 3: Automatic Hit Marker Positioning (US1)

- [X] T005 [P] [US1] Implement position randomization algorithm in addons/rhythm_generator/rhythm_timing_window.gd
- [X] T006 [P] [US1] Implement 50px boundary check logic in addons/rhythm_generator/rhythm_timing_window.gd

## Phase 4: Preserving Existing Rhythm Data (US2)

- [X] T007 [US2] Verify timestamp preservation in addons/rhythm_generator/rhythm_song.gd

## Phase 5: Polish & Verification

- [X] T008 Manual verification per specs/003-rhythm-window-positioning/quickstart.md

## Dependencies

- US1 and US2 are independent, but depend on Phase 2 completion.
- Phase 1 & 2 must be completed before any User Story phases.

## Implementation Strategy

- MVP: US1 functionality (Automatic Hit Marker Positioning).
- Incremental: Add US2 (Timestamp preservation) and Polish.
