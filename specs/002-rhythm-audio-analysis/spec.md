# Feature Specification: Rhythm Audio Analysis

**Feature Branch**: `[###-rhythm-audio-analysis]`

**Created**: 2026-08-21

**Status**: Draft

**Input**: User description: "Reading of the audio ogg vorbis file. Update the RhythmPluginTool script to handle the reading of the audio file using the established parameters for the plugin tool and the audiostreamplayer setup with "AudioEffectSpectrumAnalyzerInstance". The plugin should read the whole audio file and determine when the percussive hits happen during the song using the SpectrumAnalyzer with "get_magnitude_for_frequency_range" - it will then output a timestamp, of the percussive hit and use the deltas specified in the tool parameters to work out what a strong match and a weak match are and build up this information as an array of RhythmTimingWindow resources. Finally update the _generate_resource to use this array instead of generating the resource itself and save it to the Output Directory."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatically Generate Rhythm Timing Windows (Priority: P1)

A sound designer wants to automatically generate timing windows for percussive beats in a selected `.ogg` file to save time on manual entry.

**Why this priority**: Core automation feature.

**Independent Test**: The plugin generates a `RhythmSong` resource containing a fully populated array of `RhythmTimingWindow` resources after analyzing the audio file.

**Acceptance Scenarios**:

1. **Given** a valid `.ogg` file, **When** the plugin analyzes the audio, **Then** it detects percussive hits based on frequency magnitude thresholds and generates corresponding `RhythmTimingWindow` resources.
2. **Given** configured strong/weak match deltas, **When** hits are detected, **Then** the timing windows are correctly set with the appropriate start/end times based on the deltas.

---

## Clarifications

### Session 2026-08-21
- Q: How are percussive hits detected without a magnitude threshold? → A: Expect percussion-only audio; treat any significant energy in frequency range as a hit.
- Q: How are strong/weak match windows calculated? → A: `timestamp` is the peak of the hit. `strong_window_start` = `timestamp - 0.1ms`. `strong_window_end` = `timestamp + strong_delta`. `weak_window_start` = `timestamp - 0.1ms`. `weak_window_end` = `timestamp + weak_delta`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Plugin MUST analyze the entire `.ogg` file for percussive hits using `AudioEffectSpectrumAnalyzerInstance`.
- **FR-002**: Plugin MUST detect percussive hits by treating significant magnitude in the configured frequency range (`freq_start` to `freq_end`) as a beat (assuming percussion-only input).
- **FR-003**: Plugin MUST generate a `RhythmTimingWindow` resource for each detected hit, recording the precise `timestamp` of the hit peak.
- **FR-004**: Plugin MUST calculate "strong match" and "weak match" windows based on configured deltas:
  - Strong window: `[timestamp - 0.1ms, timestamp + strong_delta]`
  - Weak window: `[timestamp - 0.1ms, timestamp + weak_delta]`
- **FR-005**: Plugin MUST populate the `RhythmSong` timing windows array with the detected data.
- **FR-006**: Plugin MUST save the generated `RhythmSong` resource to the output directory using the audio filename as the resource name.

### Key Entities

- **RhythmSong**: The resource output by the plugin containing the timing windows.
- **RhythmTimingWindow**: The detected beat window, containing the `timestamp` of the hit, and start/end thresholds for strong and weak matches.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Plugin detects hits consistently based on the configured frequency range.
- **SC-002**: Generated `RhythmSong` resource contains the correct number of timing windows relative to the detected beats.

## Assumptions

- The `AudioEffectSpectrumAnalyzer` is correctly configured on the audio bus used by the `AudioStreamPlayer`.
- Input audio is expected to be an isolated percussion stem.
- Percussive hits are identifiable by magnitude spikes in the specified frequency range.
