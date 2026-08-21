# Quickstart: Rhythm Song Plugin

## Overview
This plugin allows sound designers to generate `RhythmSong` resources from `.ogg` audio files within the Godot editor.

## Prerequisites
- Godot 4.x project open.
- `RhythmSong` and `RhythmTimingWindow` scripts exist.
- `music_reader.tscn` is set up.

## Setup
1. Attach `rhythm_plugin_tool.gd` to a node in `music_reader.tscn` or a new scene.
2. Ensure the node is in a scene currently open in the Godot Editor.

## Validation Scenarios
1. **Scenario: Generate Valid Resource**
   - In the Editor, select the `RhythmPluginTool` node.
   - Set `Ogg File Path` to a valid `.ogg` file in the project.
   - Set `Freq Start` and `Freq End` (e.g., 20.0 to 20000.0).
   - Set `Strong Match Delta` and `Weak Match Delta` (e.g., 0.05, 0.1).
   - Set `Output Path` (e.g., `res://songs/song1/rhythm_song.tres`).
   - Click the "Generate RhythmSong" button in the Editor UI.
   - **Outcome**: The file should appear in the FileSystem dock at the specified location.

2. **Scenario: Handle Missing File**
   - Leave `Ogg File Path` empty.
   - Click "Generate RhythmSong".
   - **Outcome**: An error message appears in the Output console.
