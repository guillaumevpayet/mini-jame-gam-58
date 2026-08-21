# Feature Specification: Rhythm Song Plugin

**Feature Branch**: `[###-rhythm-song-plugin]`

**Created**: 2026-08-21

**Status**: Draft

**Input**: User description: "Initial godot plugin setup. The gd extension must read in a .ogg audio file and output a RhythmSong resource with the timing_windows array fully populated containing all timing windows for percussive beats in the .ogg audio file which the extension must read. It will accept a starting frequency and an end frequency as exported variables. There are a number of scripts set up already to begin with including the "MusicReaderController" which gets the spectrum analyzer and has the initial resource script files "RhythmSong" and "RhythmTimingWindow" ready. It also had an audio bus with the analyzer effect added. The plugin must allow the user to input a .ogg file and the starting & ending frequency as well as a delta for the "strong match" timing window and a "weak match" timing window. Do NOT add any logic for track analysis yet, to start with the extension must be created which accepted the stated input and outputs a resource (suing the defined resource scripts_ to a configurable location."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generate Rhythm Song Resource (Priority: P1)

A sound designer wants to generate a `RhythmSong` resource from a selected `.ogg` audio file to use in the rhythm game.

**Why this priority**: This is the core functionality of the feature.

**Independent Test**: The sound designer can select a file, configure parameters, and successfully save a `RhythmSong` resource file to the specified location.

**Acceptance Scenarios**:

1. **Given** an existing `.ogg` audio file, **When** the sound designer selects the file and provides configuration parameters (start freq, end freq, strong/weak deltas) and an output path, **Then** a `RhythmSong` resource is generated and saved at the output path.
2. **Given** no `.ogg` file selected, **When** the sound designer attempts to generate the resource, **Then** an error message is displayed indicating that a file must be selected.

---

### Edge Cases

- What happens when the selected output path is invalid or unwritable?
- How does the system handle an audio file that cannot be read or parsed?
- What happens when invalid frequency ranges or deltas are provided?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Plugin MUST allow the user to select an input `.ogg` audio file, which must be an `AudioStreamOggVorbis` resource.
- **FR-002**: Plugin MUST allow the user to configure a starting frequency (as a float).
- **FR-003**: Plugin MUST allow the user to configure an ending frequency (as a float).
- **FR-004**: Plugin MUST allow the user to configure a delta for the "strong match" timing window (as a float).
- **FR-005**: Plugin MUST allow the user to configure a delta for the "weak match" timing window (as a float).
- **FR-006**: Plugin MUST allow the user to configure the output path for the generated `RhythmSong` resource.
- **FR-007**: Plugin MUST validate that an `.ogg` file has been selected before generating the resource.
- **FR-008**: Plugin MUST generate a `RhythmSong` resource, saving it to the configured output path.
- **FR-009**: Plugin MUST handle file saving errors gracefully and inform the user.

### Key Entities

- **RhythmSong**: The resource output by the plugin.
- **RhythmTimingWindow**: The timing windows contained within the `RhythmSong`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Sound designers can successfully generate a `RhythmSong` resource file in under 1 minute.
- **SC-002**: 100% of valid configuration inputs result in a saved `RhythmSong` resource file.
- **SC-003**: Users receive clear, actionable feedback when configuration is invalid or saving fails.

## Assumptions

- The plugin will run within the Godot editor environment as a tool script.
- The `RhythmSong` and `RhythmTimingWindow` resource scripts are already available and usable.
- The user is responsible for providing valid file paths and numerical values.
