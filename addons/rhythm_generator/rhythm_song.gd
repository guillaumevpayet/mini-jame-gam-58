extends Resource
class_name RhythmSong

@export_category("Scoring Data")
@export var minimum_target_score: int
@export var score_deduction_for_miss: int
@export var score_increase_for_high_hit: int
@export var score_increase_for_low_hit: int
@export_category("Rhythm Windows")
@export var timing_windows: Array[RhythmTimingWindow]
