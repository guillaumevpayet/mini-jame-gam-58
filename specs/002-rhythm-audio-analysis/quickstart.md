# Quickstart: Rhythm Audio Analysis

## Overview
This feature adds automatic beat detection to the `RhythmPluginTool`, allowing generation of `RhythmSong` resources from percussion-only `.ogg` files without manual timing window entry.

## Prerequisites
- A percussion-only `.ogg` audio file (`AudioStreamOggVorbis`).
- `AudioEffectSpectrumAnalyzer` configured on the music bus.
- `RhythmPluginTool` node with `AudioStreamPlayer` (connected to the bus).

## Validation Scenarios
1. **Scenario: Automatically Generate Windows**
   - In the Editor, select the `RhythmPluginTool` node.
   - Assign the percussion `.ogg` file to `Ogg Stream`.
   - Set parameters (`Freq Start/End`, `Strong/Weak Match Delta`).
   - Toggle `Generate Button`.
   - **Outcome**: A `RhythmSong` resource is generated in the output directory, populated with `RhythmTimingWindow` resources based on detected hits.
