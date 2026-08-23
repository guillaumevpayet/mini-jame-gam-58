extends AnimatedSprite2D


@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var _combo: int = 0


func _ready() -> void:
	play()


func _on_frame_changed() -> void:
	if frame > _combo or (frame == 0 and _combo > 0):
		frame = _combo - 1


func _on_main_game_scene_combo_changed(combo: int) -> void:
	if combo == 0:
		_audio_stream_player.stop()
	else:
		_audio_stream_player.volume_db = 2 * (combo - 12)
		
		if _combo == 0:
			_audio_stream_player.play()
	
	_combo = combo
