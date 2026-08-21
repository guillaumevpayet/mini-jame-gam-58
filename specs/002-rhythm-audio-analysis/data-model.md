# Data Model: Rhythm Audio Analysis

## Entities

### RhythmSong
- `timing_windows`: `Array[RhythmTimingWindow]`

### RhythmTimingWindow
- `timestamp`: `float`
- `strong_window_start`: `float`
- `strong_window_end`: `float`
- `weak_window_start`: `float`
- `weak_window_end`: `float`

### Plugin Configuration (Internal/Transient)
- `ogg_stream`: `AudioStreamOggVorbis`
- `freq_start`: `float`
- `freq_end`: `float`
- `strong_match_delta`: `float`
- `weak_match_delta`: `float`
- `output_directory`: `String`
