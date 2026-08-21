# Tasks: Rhythm Audio Analysis

**Branch**: `002-rhythm-audio-analysis` | **Spec**: [spec.md](spec.md)

## Implementation Strategy
- **MVP Focus**: Implement audio hit detection logic in `RhythmPluginTool` to generate `RhythmTimingWindow` resources.
- **Incremental Delivery**: Start with analyzer setup, then implement the analysis loop, and finally update the `_generate_resource` method to output the fully populated `RhythmSong`.

## Phases

### Phase 1: Setup
- [ ] T001 Setup documentation files.

### Phase 2: Foundational
- [ ] T002 Verify existence of necessary resource scripts.

### Phase 3: User Story 1 - Automatically Generate Rhythm Timing Windows (Priority: P1)
- [X] T003 [US1] Update `addons/rhythm_generator/rhythm_plugin_tool.gd` to initialize the `AudioEffectSpectrumAnalyzerInstance` using configured bus/effect indices.
- [X] T004 [US1] Implement audio processing loop in `addons/rhythm_generator/rhythm_plugin_tool.gd` to iterate through the audio file and detect hits using `get_magnitude_for_frequency_range`.
- [X] T005 [US1] Implement timing window calculation logic (`timestamp`, `strong_match_delta`, `weak_match_delta`) in `addons/rhythm_generator/rhythm_plugin_tool.gd`.
- [X] T006 [US1] Populate `RhythmSong` timing windows array with detected `RhythmTimingWindow` resources in `addons/rhythm_generator/rhythm_plugin_tool.gd`.
- [X] T007 [US1] Update `_generate_resource` in `addons/rhythm_generator/rhythm_plugin_tool.gd` to save the populated `RhythmSong` instead of an empty one.

### Phase 4: Polish
- [X] T008 Optimize audio analysis performance for editor usage in `addons/rhythm_generator/rhythm_plugin_tool.gd`.

## Task Dependencies
- T002 -> T003
- T003 -> T004
- T004 -> T005
- T005 -> T006
- T006 -> T007
- T007 -> T008

## Parallel Execution Opportunities
- T003 and T004 can be partially developed in parallel.
