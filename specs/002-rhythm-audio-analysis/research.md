# Research: Rhythm Audio Analysis

## Summary
- Decision: Implement audio analysis directly within `RhythmPluginTool` using `AudioEffectSpectrumAnalyzerInstance`.
- Rationale: Direct access to real-time audio data and existing plugin state for hit detection.
- Alternatives considered: Separate analysis script/node. Rejected because the requirement is to keep all changes within `RhythmPluginTool`.

## Research Findings

### Hit Detection Logic
- `AudioEffectSpectrumAnalyzerInstance.get_magnitude_for_frequency_range(freq_start, freq_end)` provides the magnitude of the audio signal in a specific frequency range.
- Since input is a percussion stem, hits can be detected by tracking magnitude spikes.
- A simple peak detection algorithm is needed: if current magnitude > moving average * threshold, count as hit.

### Timing Window Calculation
- `timestamp` is the hit time.
- `strong_window_start` = `timestamp - 0.1ms`
- `strong_window_end` = `timestamp + strong_delta`
- `weak_window_start` = `timestamp - 0.1ms`
- `weak_window_end` = `timestamp + weak_delta`

## Unresolved Issues/Clarifications Resolved
- Hit detection logic resolved: Percussion stem assumed, significant magnitude = hit.
- Timing calculation resolved: Peak based, symmetric start (0.1ms), delta-based end.
