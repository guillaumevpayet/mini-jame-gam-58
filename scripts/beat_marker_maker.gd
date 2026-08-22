extends Node


@export var song: RhythmSong
@export var beat_marker: PackedScene
@export var gameOverLabel: Label

## Time to spawn the beat marker before the beat, in seconds.
@export var time_before_beat: float


signal score_changed(score: int)


@onready var _audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


var _next_timing_window_index: int
var _score: int


# func _ready() -> void:
# 	_audio_stream_player.stream = song.audio_stream

func _process(_delta: float) -> void:
	var playback_position: float = _audio_stream_player.get_playback_position()
	var half_delta: float = 0.5 * _delta

	if _next_timing_window_index >= song.timing_windows.size():
		return
	
	var timing_window: RhythmTimingWindow = song.timing_windows[_next_timing_window_index]
	
	if playback_position > timing_window.timestamp - time_before_beat:
		_create_beat_marker(timing_window.position)
		_next_timing_window_index += 1


func _create_beat_marker(marker_position: Vector2):
	var marker: BeatMarker = beat_marker.instantiate()
	marker.init(marker_position, time_before_beat)
	marker.score_obtained.connect(_on_BeatMarker_score_obtained)
	add_child(marker)


func _on_BeatMarker_score_obtained(score: int):
	match score:
		0:
			pass
		1:
			_score += song.score_increase_for_low_hit
		2:
			_score += song.score_increase_for_high_hit
	
	$Label.text = "Score: " + str(_score) + " / " + str(song.minimum_target_score)
	score_changed.emit(_score)


func _on_audio_stream_player_2d_finished() -> void:
	if _score < song.minimum_target_score:
		gameOverLabel.text = "You lose"
	else:
		gameOverLabel.text = "You win!"
		
	gameOverLabel.visible = true
