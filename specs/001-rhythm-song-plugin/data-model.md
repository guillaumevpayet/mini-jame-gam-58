# Data Model: Rhythm Song Plugin

## Entities

### RhythmSong
- `minimum_target_score`: `int` (From existing script)
- `score_deduction_for_miss`: `int` (From existing script)
- `score_increase_for_high_hit`: `int` (From existing script)
- `score_increase_for_low_hit`: `int` (From existing script)
- `timing_windows`: `Array[RhythmTimingWindow]` (From existing script)

### RhythmTimingWindow
- `timestamp`: `float`
- `high_window_start`: `float`
- `high_window_end`: `float`
- `low_window_start`: `float`
- `low_window_end`: `float`

### Plugin Configuration (Internal/Transient)
- `ogg_file_path`: `String`
- `freq_start`: `float`
- `freq_end`: `float`
- `strong_match_delta`: `float`
- `weak_match_delta`: `float`
- `output_path`: `String`
