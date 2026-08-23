extends Node
class_name MainGameScene


@export var song: RhythmSong
@export var beat_marker: PackedScene

## Time to spawn the beat marker before the beat, in seconds.
@export var time_before_beat: float
@export var beat_lifetime: float
@export var miss_tolerance: int = 3
@export var max_combo: int = 12


signal score_changed(score: int, minimum_target_score: int)
signal combo_changed()
signal game_over(perfect_count: int, ok_count: int, miss_count: int, win: bool)

@onready var countdown_label: Label = $CoundownDisplay/Label
@onready var countdown_interval: Timer = $CountdownInterval

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var percussions_audio_stream_player_2d: AudioStreamPlayer2D = $PercussionsAudioStreamPlayer2D
@onready var coundown_display: Control = $CoundownDisplay
@onready var allow_playback_sync: Timer = $AllowPlaybackSync

var _countdown: int = 3
var _next_timing_window_index: int
var _score: int
var _miss_streak: int = 0
var _song_timings: Array[RhythmTimingWindow]
var _perfect_count: int = 0
var _ok_count: int = 0
var _miss_count: int = 0
var _active_beat_markers: Array[BeatMarker]

var _game_clock: float = 0.0
var _sync_threshold: float = 0.05
var _allow_playback_sync: bool = false

func _ready() -> void:
	score_changed.emit(_score, song.minimum_target_score)
	combo_changed.emit()
	_song_timings = song.timing_windows
	_song_timings.sort_custom(func(a: RhythmTimingWindow, b: RhythmTimingWindow): return a.timestamp < b.timestamp)
	get_viewport().physics_object_picking_sort = true      # order by z_index / tree order
	get_viewport().physics_object_picking_first_only = true # only the "top" one gets the event
	audio_stream_player_2d.seek(0.0)
	percussions_audio_stream_player_2d.seek(0.0)

func _process(delta: float) -> void:
	if _countdown > 0:
		return
		
	handle_song_timing(delta)
	handle_mouse_input()
		
		
func handle_mouse_input() -> void:
	if !Input.is_action_just_pressed("hit_beat"):
		return

	var mouse_pos = get_viewport().get_mouse_position()
	
	var target_marker: BeatMarker = null
	
	# Find the marker that was actually clicked. 
	# BeatMarker is an Area2D with a max_radius.
	for marker in _active_beat_markers:
		if mouse_pos.distance_to(marker.position) <= marker.max_radius:
			target_marker = marker
			break
	
	if target_marker:
		target_marker.determine_click_score(mouse_pos)
	elif _active_beat_markers.size() > 0:
		# If no marker was clicked, penalize the oldest marker.
		_active_beat_markers[0]._emit_score_and_disappear(0)
		
func handle_song_timing(delta: float) -> void:
	if _next_timing_window_index >= _song_timings.size():
		return
	
	_game_clock += delta
	
	var playback_position: float = percussions_audio_stream_player_2d.get_playback_position()

	if abs(_game_clock - playback_position) > _sync_threshold && _allow_playback_sync:
		_game_clock = playback_position

	var timing_window: RhythmTimingWindow = _song_timings[_next_timing_window_index]
	
	if _game_clock > timing_window.timestamp - time_before_beat:
		_create_beat_marker(timing_window.position)
		_next_timing_window_index += 1

func _create_beat_marker(marker_position: Vector2):
	var marker: BeatMarker = beat_marker.instantiate()
	marker.init(marker_position, beat_lifetime)
	marker.score_obtained.connect(_on_BeatMarker_score_obtained)
	marker.despawn.connect(_on_marker_despawn)
	$BeatMarkersContainer.add_child(marker)
	$BeatMarkersContainer.move_child(marker, 0)
	_active_beat_markers.append(marker)

func _on_marker_despawn(marker: BeatMarker) -> void:
	_active_beat_markers.erase(marker)
	marker.queue_free()
	
func _on_BeatMarker_score_obtained(score: int):
	match score:
		0:
			_miss_count += 1
			_miss_streak += 1
			Globals.current_combo = 0
		_: # 1 & 2 are ok
			_ok_count += 1
			_score += song.score_increase_for_low_hit * (1 + Globals.current_combo)
			_miss_streak = 0
			Globals.current_combo += 1
		3: 
			_perfect_count += 1
			_score += song.score_increase_for_high_hit * (1 + Globals.current_combo)
			_miss_streak = 0
			Globals.current_combo += 1
		
	if Globals.current_combo > max_combo:
		Globals.current_combo = max_combo
	
	score_changed.emit(_score, song.minimum_target_score)
	combo_changed.emit()

	if _miss_streak >= miss_tolerance:
		game_over.emit(_perfect_count, _ok_count, _miss_count, false)


func _on_audio_stream_player_2d_finished() -> void:
	game_over.emit(_perfect_count, _ok_count, _miss_count, _score >= song.minimum_target_score)


func _on_countdown_interval_timeout() -> void:
	_countdown -= 1
	
	countdown_label.text = str(_countdown)
	
	if _countdown <= 0: 
		allow_playback_sync.start()
		_countdown = 0
		countdown_interval.stop()
		coundown_display.hide()
		
		audio_stream_player_2d.play()
		percussions_audio_stream_player_2d.play()


func _on_allow_playback_sync_timeout() -> void:
	_allow_playback_sync = true
