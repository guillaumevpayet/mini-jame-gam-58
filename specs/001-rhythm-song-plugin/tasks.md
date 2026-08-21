# Tasks: Rhythm Song Plugin

**Branch**: `001-rhythm-song-plugin` | **Spec**: [spec.md](spec.md)

## Implementation Strategy
- **MVP Focus**: Implement the tool script node to allow generating and saving the `RhythmSong` resource.
- **Incremental Delivery**: Start with setup, then implement the tool UI logic, and finally the resource saving functionality.

## Phases

### Phase 1: Setup
- [X] T001 Setup directory structure and documentation files (already created via specification/planning).

### Phase 2: Foundational
- [X] T002 Verify existence of `RhythmSong` and `RhythmTimingWindow` resource scripts in `scripts/music_reader/`.

### Phase 3: User Story 1 - Generate Rhythm Song Resource (Priority: P1)
- [X] T003 [US1] Create the tool script `scripts/music_reader/rhythm_plugin_tool.gd` with `@tool` annotation.
- [X] T004 [US1] Add exported variables for `.ogg` file, frequencies, match deltas, and output path in `scripts/music_reader/rhythm_plugin_tool.gd`.
- [X] T005 [US1] Implement UI button in `scripts/music_reader/rhythm_plugin_tool.gd` to trigger resource generation.
- [X] T006 [US1] Implement `_generate_resource()` logic to instantiate `RhythmSong`, set timing windows (empty initially), and save using `ResourceSaver` in `scripts/music_reader/rhythm_plugin_tool.gd`.
- [X] T007 [US1] Implement input validation to ensure an `.ogg` file is selected and is an `AudioStreamOggVorbis` resource before generating the resource in `scripts/music_reader/rhythm_plugin_tool.gd`.

### Phase 4: Polish
- [X] T008 Add error handling and user feedback for file saving errors in `scripts/music_reader/rhythm_plugin_tool.gd`.

## Task Dependencies
- T002 -> T003
- T003 -> T004
- T004 -> T005
- T005 -> T006
- T006 -> T007
- T007 -> T008

## Parallel Execution Opportunities
- T002 can be done in parallel with T003 (as it just verifies existence).
- UI implementation (T005) and logic implementation (T006) can be partially developed in parallel.
