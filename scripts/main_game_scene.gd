extends Node
class_name MainGameScene


@export var song: RhythmSong
@export var beat_marker: PackedScene

## Time to spawn the beat marker before the beat, in seconds.
@export var time_before_beat: float
@export var miss_tolerance: int = 3
@export var max_combo: int = 12


signal score_changed(score: int, minimum_target_score: int)
signal combo_changed(combo: int)
signal game_over(perfect_count: int, ok_count: int, miss_count: int, win: bool)


@onready var _audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


var _next_timing_window_index: int
var _score: int
var _miss_streak: int = 0
var _combo: int = 0
var _song_timings: Array[RhythmTimingWindow]
var _perfect_count: int = 0
var _ok_count: int = 0
var _miss_count: int = 0

func _ready() -> void:
	score_changed.emit(_score, song.minimum_target_score)
	combo_changed.emit(_combo)
	_song_timings = song.timing_windows
	_song_timings.sort_custom(func(a: RhythmTimingWindow, b: RhythmTimingWindow): return a.timestamp < b.timestamp)
	get_viewport().physics_object_picking_sort = true      # order by z_index / tree order
	get_viewport().physics_object_picking_first_only = true # only the "top" one gets the event

func _process(_delta: float) -> void:
	var playback_position: float = _audio_stream_player.get_playback_position()

	if _next_timing_window_index >= _song_timings.size():
		return
	
	var timing_window: RhythmTimingWindow = _song_timings[_next_timing_window_index]
	
	if playback_position > timing_window.timestamp - time_before_beat:
		_create_beat_marker(timing_window.position)
		_next_timing_window_index += 1


func _create_beat_marker(marker_position: Vector2):
	var marker: BeatMarker = beat_marker.instantiate()
	marker.init(marker_position, time_before_beat)
	marker.score_obtained.connect(_on_BeatMarker_score_obtained)
	$BeatMarkersContainer.add_child(marker)
	$BeatMarkersContainer.move_child(marker, 0)


func _on_BeatMarker_score_obtained(score: int):
	match score:
		0:
			_miss_count += 1
			_miss_streak += 1
			_combo = 0
		1:
			_ok_count += 1
			_score += song.score_increase_for_low_hit * (1 + _combo)
			_miss_streak = 0
			_combo += 1
		2:
			_perfect_count += 1
			_score += song.score_increase_for_high_hit * (1 + _combo)
			_miss_streak = 0
			_combo += 1
		
	if _combo > max_combo:
		_combo = max_combo
	
	score_changed.emit(_score, song.minimum_target_score)
	combo_changed.emit(_combo)

	if _miss_streak >= miss_tolerance:
		game_over.emit(_perfect_count, _ok_count, _miss_count, false)


func _on_audio_stream_player_2d_finished() -> void:
	game_over.emit(_perfect_count, _ok_count, _miss_count, _score >= song.minimum_target_score)
